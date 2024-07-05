extends TextureRect

var pr : float = 0
var part_rotation : float:
	get: return pr
	set(v):
		pr = v
		$gnomon.rotation = pr
		dial_changed.emit(pr)
signal dial_changed(value:float)

func _gui_input(event):
	if event is InputEventMouse and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		var p = event.position - (get_rect().size/2)
		part_rotation = p.angle()
		$gnomon.rotation = part_rotation
		dial_changed.emit(part_rotation)

func _set_rotation_no_signal(r: float):
	pr = r
	$gnomon.rotation = pr
