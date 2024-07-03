extends Tree

var root
# Called when the node enters the scene tree for the first time.
func _ready():
	root = create_item()
	populate()


func populate():
	for item in root.get_children(): item.free()
	if not "images" in _FileBoss.data: return
	for image in _FileBoss.data.images:
		if not "slices" in _FileBoss.data.images[image]: continue
		var img = create_item(root)
		img.set_text(0, image)
		for sid in _FileBoss.data.images[image].slices.size():
			var slice = _FileBoss.data.images[image].slices[sid]
			var sl = create_item(img)
			sl.set_text(0,slice.pid)
			sl.set_metadata(0, slice)
			sl.add_button(1, preload("res://plusicon.svg"))
			sl.set_metadata(1, sid)


func _on_button_clicked(item, _column, _id, _mouse_button_index):
	if not owner.current_frame: return
	if not "parts" in owner.current_frame:
		owner.current_frame["parts"] = []
	owner.current_frame.parts.append({"img": item.get_metadata(0).image, \
			"slice": item.get_metadata(1), "position": Vector2.ZERO, \
			"scale": Vector2.ONE, "skew": 0.0, "rotation": 0.0, \
			"flip_h": false, "flip_v": false, "alpha": 1.0})
	get_tree().call_group("frame_bits_manager", "populate")
	
