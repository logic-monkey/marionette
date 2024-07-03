extends Control
class_name MAR_PART

var part : Dictionary :
	set(value):
		part = value
		if "image" in part: $Sprite2D.texture = _FileBoss.images[part.image]
		if "rect" in part:
			$Sprite2D.region_rect = part.rect
			var scale1 = 200.0 / part.rect.size.x
			var scale2 = 180.0 / part.rect.size.y
			if scale2 < scale1: scale1 = scale2
			$Sprite2D.scale = Vector2(scale1, scale1)
		if "pid" in part: $LineEdit.text = part.pid

signal delete
func balete():
	delete.emit()


func _on_line_edit_text_changed(new_text):
	part.pid = new_text
	get_tree().call_group("slice_manager", "populate")
		
