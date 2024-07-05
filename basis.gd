extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	%menu.get_popup().index_pressed.connect(_on_menu_item_picked)
	_FileBoss.fialogue = $Fialogue
	_FileBoss.zoom_changed.connect(_on_zoom_changed)

func _on_menu_item_picked(index):
	if index != 2: _FileBoss.fialogueMode = index
	match index:
		0:
			pass
		1:
			pass
		2:
			pass
		3:
			pass
	
	$Fialogue.show()

func new():
	pass
	
func Save():
	pass

func Load():
	pass
	


func _on_fialogue_file_selected(path):
	if _FileBoss.fialogueMode < 0 or _FileBoss.fialogueMode > 3: return
	pass # Replace with function body.


func _on_fialogue_canceled():
	_FileBoss.fialogueMode = -1
	

func _on_zoom_edit_text_submitted(new_text:String):
	if new_text.is_valid_float():
		var z = new_text.to_float() / 100
		z = clamp(z,0.1,100.0)
		_FileBoss.zoom = z
	else:
		_on_zoom_changed()

func _on_zoom_changed():
	%zoom_edit.text = "%s" % (_FileBoss.zoom * 100)


func _on_zoom_out_button_down():
	_FileBoss.zoom -= 0.25


func _on_zoom_in_button_down():
	_FileBoss.zoom +=0.25
