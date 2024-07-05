extends Control

func _ready():
	_FileBoss.zoom_changed.connect(set_image_size)

var current_image :String = ""
func _on_add_image_pressed():
	var f : FileDialog = _FileBoss.fialogue
	if not f: return
	_FileBoss.fialogueMode = 4
	if not f.file_selected.is_connected(_on_fialogue_file_selected): f.file_selected.connect(_on_fialogue_file_selected)
	f.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	f.filters = ["*.png ; PNG Images"]
	f.show()
	
func _on_fialogue_file_selected(path:String):
	#print("file selected")
	if _FileBoss.fialogueMode != 4:
		print(_FileBoss.fialogueMode)
		return
	#if not path.is_valid_filename():
		#print (path)
		#return
	if not FileAccess.file_exists(path): 
		print ("image file not found")
		return
	var img_name : String = path.get_file().get_basename()
	if not "images" in _FileBoss.data: _FileBoss.data["images"] = {}
	_FileBoss.data.images[img_name] = {"path": path}
	#print(img_name)
	var img = Image.new()
	img.load(path)
	_FileBoss.images[img_name] = ImageTexture.new()
	_FileBoss.images[img_name].set_image(img)
	populate_image_list()
	var idx = _FileBoss.data.images[img_name].iln
	%image_list.select(idx)
	_on_image_list_item_selected(idx)
	#above does not trigger signal; call loading stuff here
	

func populate_image_list():
	%image_list.clear()
	if not "images" in _FileBoss.data:
		return
	for i in _FileBoss.data.images:
		%image_list.add_item(i)
		if not i in _FileBoss.images:
			var img = Image.new()
			img.load(_FileBoss.data.images[%image_list.get_item_text(i)].path)
			_FileBoss.images[i] = ImageTexture.new()
			_FileBoss.images[i].set_image(img)
	%image_list.sort_items_by_text()
	for i in %image_list.item_count:
		_FileBoss.data.images[%image_list.get_item_text(i)]["iln"] = i
		
	
func _on_image_list_item_selected(index):
	%current_image.texture = _FileBoss.images[%image_list.get_item_text(index)]
	current_image = %image_list.get_item_text(index)
	set_image_size()
	%rectangle_artist.current_image = current_image
	%rectangle_artist.queue_redraw()
	update_part_list()
	
var is_dragging : bool = false
var current_rect = -1
#var zoom : float = 1.0
func _input(event: InputEvent):
	if not visible: return
	if not %image_window.get_rect().has_point(%image_window.get_parent().get_local_mouse_position()): return
	if current_image.is_empty(): return
	var cur = _FileBoss.data.images[current_image]
	var img_rect = %current_image.get_global_rect()
	var mouse = %current_image.get_local_mouse_position() / _FileBoss.zoom
	if not is_dragging and event is InputEventMouseButton\
			and event.button_index == 1 and event.pressed\
			and img_rect.has_point(event.position):
		is_dragging = true
		#print(mouse)
		if not "slices" in cur:
			cur["slices"] = []
		cur.slices.append(\
				{
					"rect": Rect2(mouse, Vector2(1,1)),
					"initial_point": Rect2(mouse, Vector2(1,1)),
					"pid": "%s_%s" % [current_image, cur.slices.size()],
					"image": current_image,
				})
		current_rect = cur.slices.size() - 1
		accept_event()
		%rectangle_artist.current_image = current_image
		%rectangle_artist.call_deferred("queue_redraw")
	elif is_dragging and event is InputEventMouseButton\
			and event.button_index == 1 and not event.pressed:
		current_rect = -1
		is_dragging = false
		accept_event()
		%rectangle_artist.current_image = current_image
		%rectangle_artist.call_deferred("queue_redraw")
		update_part_list()
		get_tree().call_group("slice_manager", "populate")
	elif is_dragging and event is InputEventMouseMotion:
		var loc = (mouse).clamp(Vector2.ZERO, %current_image.get_rect().size/_FileBoss.zoom)
		var r = cur.slices[current_rect].initial_point
		r = r.expand(loc)
		
		cur.slices[current_rect].rect = r
		accept_event()
		%rectangle_artist.current_image = current_image
		%rectangle_artist.call_deferred("queue_redraw")
	elif event is InputEventMouseButton and event.shift_pressed and event.pressed\
			and (event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_FileBoss.zo00m -= 0.1
		else:
			_FileBoss.zoom += 0.1
		set_image_size()
		%rectangle_artist.current_image = current_image
		%rectangle_artist.call_deferred("queue_redraw")
		accept_event()
		
func set_image_size():
	if current_image.is_empty(): return
	%current_image.custom_minimum_size = _FileBoss.images[current_image].get_size() * _FileBoss.zoom
	%current_image.pivot_offset = %current_image.custom_minimum_size/2
	
var scrollx = 0
var scrolly = 0
func _process(_delta):
	if scrollx != %image_window.scroll_horizontal or scrolly != %image_window.scroll_vertical:
		%rectangle_artist.current_image = current_image
		%rectangle_artist.call_deferred("queue_redraw")
	scrollx = %image_window.scroll_horizontal
	scrolly = %image_window.scroll_vertical

func update_part_list():
	for p in %part_container.get_children():
		%part_container.remove_child(p)
		p.queue_free()
	if current_image.is_empty(): return
	var cur = _FileBoss.data.images[current_image]
	if not "slices" in cur: return
	var counter = 0
	for slice in cur.slices:
		var part = preload("res://image slicer/part.tscn").instantiate() as MAR_PART
		%part_container.add_child(part)
		part.part = slice
		part.delete.connect(delete_part.bind(counter))
		counter += 1
	%rectangle_artist.queue_redraw()

func delete_part(index):
	if current_image.is_empty(): return
	var cur = _FileBoss.data.images[current_image]
	if not "slices" in cur: return
	if index < 0 or index >= cur.slices.size(): return
	cur.slices.remove_at(index)
	update_part_list()
	
