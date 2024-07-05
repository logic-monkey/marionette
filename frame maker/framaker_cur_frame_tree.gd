extends Tree

var root : TreeItem

func _ready():
	root = create_item()


func populate():
	owner.current_piece = null
	for child in root.get_children():
		child.free()
	for child in %origin.get_children():
		child.queue_free()
	if not owner.current_frame: return
	if not "parts" in owner.current_frame: return
	for part in owner.current_frame.parts:
		var item = create_item(root)
		var slice = _FileBoss.data.images[part.img].slices[part.slice]
		item.set_metadata(0, part)
		item.set_text(0, slice.pid)
		item.add_button(1,preload('res://xicon.svg'))
		var sprite = Sprite2D.new()
		%origin.add_child(sprite)
		item.set_metadata(1, sprite)
		sprite.texture = _FileBoss.images[slice.image]
		sprite.region_enabled = true
		sprite.region_rect = slice.rect
		set_piece(part, sprite)

func _on_button_clicked(item, column, id, mouse_button_index):
	match column:
		1:
			# Baleted
			owner.current_frame.parts.erase(item.get_metadata(0))
			item.get_metadata(1).queue_free()
			get_tree().call_group.call_deferred("frame_bits_manager", "populate")

func _get_drag_data(at_position):
	return get_item_at_position(at_position)
	
func _can_drop_data(at_position, data):
	drop_mode_flags = DROP_MODE_INBETWEEN
	if not data is TreeItem: return false
	var d = data.get_metadata(0)
	if not d is Dictionary: return false
	return d in owner.current_frame.parts

func _drop_data(at_position, data):
	var location = 0
	var drop_pose = get_drop_section_at_position(at_position)
	var d = data.get_metadata(0)
	match drop_pose:
		-1: pass
		1: location+=1
		_: return
	owner.current_frame.parts.erase(d)
	var item = get_item_at_position(at_position)
	location += owner.current_frame.parts.find(item.get_metadata(0))
	owner.current_frame.parts.insert(location, d)
	get_tree().call_group.call_deferred("frame_bits_manager", "populate")


func _on_item_selected():
	owner.current_piece = get_selected()
	part_loading = true
	refresh_dial(owner.current_piece.get_metadata(0))
	part_loading = false

var part_loading : = false
func _on_part_manipulator_part_updated():
	if part_loading: return
	if not owner.current_piece is TreeItem: return
	part_loading = true
	var part = owner.current_piece.get_metadata(0)
	var sprite = owner.current_piece.get_metadata(1)
	part["scale"] = %"part manipulator".part_scale
	part["skew"] = %"part manipulator".part_skew
	part["rotation"] = %"part manipulator".part_rotation
	part["flip_h"] = %"part manipulator".part_hflip
	part["flip_v"] = %"part manipulator".part_vflip
	part["alpha"] = %"part manipulator".part_alpha
	part_loading = false
	set_piece(part, sprite)
	
func set_piece(part:Dictionary, sprite:Sprite2D):
	if "position" in part: sprite.position = part.position
	if "scale" in part: sprite.scale = part.scale
	if "skew" in part: sprite.skew = part.skew * 1.56
	if "rotation" in part: sprite.rotation = part.rotation
	if "flip_h" in part: sprite.flip_h = part.flip_h
	if "flip_v" in part: sprite.flip_v = part.flip_v
	if "alpha" in part: sprite.modulate = Color(1.0,1.0,1.0,part.alpha)
	
func refresh_dial(part:Dictionary):
	if "scale" in part: %"part manipulator".part_scale = part.scale
	if "skew" in part: %"part manipulator".part_skew = part.skew
	if "rotation" in part: %"part manipulator".part_rotation = part.rotation
	if "flip_h" in part: %"part manipulator".part_hflip = part.flip_h
	if "flip_v" in part: %"part manipulator".part_vflip = part.flip_v
	if "alpha" in part: %"part manipulator".part_alpha = part.alpha
