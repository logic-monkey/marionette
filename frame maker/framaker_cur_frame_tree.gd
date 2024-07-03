extends Tree

var root : TreeItem

func _ready():
	root = create_item()


func populate():
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
		if "position" in part: sprite.position = part.position
		if "scale" in part: sprite.scale = part.scale
		if "rotation" in part: sprite.rotation = part.rotation
		if "flip_h" in part: sprite.flip_h = part.flip_h
		if "flip_v" in part: sprite.flip_v = part.flip_v
		if "alpha" in part: sprite.modulate = Color(1.0,1.0,1.0,part.alpha)
		
		
