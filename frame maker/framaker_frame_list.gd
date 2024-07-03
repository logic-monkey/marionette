extends ItemList

func populate():
	clear()
	var last_current_frame = owner.current_frame
	owner.current_frame = null
	if not "frames" in _FileBoss.data: return
	for frame in _FileBoss.data.frames:
		var idx = add_item(frame.name)
		set_item_metadata(idx, frame)
		if frame == last_current_frame:
			owner.current_frame = frame
			call_deferred("select",idx)
			call_deferred("_on_item_selected", idx)
			get_tree().call_group.call_deferred("frame_bits_manager", "populate")
	


func _on_new_frame_pressed():
	if not "frames" in _FileBoss.data:
		_FileBoss.data["frames"] = []
	_FileBoss.data.frames.append({"name": "new frame"})
	get_tree().call_group("frame_manager", "populate")
	call_deferred("select",item_count-1)
	call_deferred("_on_item_selected", item_count-1)
	get_tree().call_group.call_deferred("frame_bits_manager", "populate")


func _on_item_selected(index):
	if not "frames" in _FileBoss.data: return
	owner.current_frame = _FileBoss.data.frames[index]
	%cur_frame_name.text = owner.current_frame.name
	get_tree().call_group.call_deferred("frame_bits_manager", "populate")

func _on_item_clicked(index, _at_position, mouse_button_index):
	if mouse_button_index == MOUSE_BUTTON_RIGHT:
		var locRec = get_item_rect(index)
		locRec.position += global_position
		%frame_menu.position = locRec.get_center()
		%frame_menu.show()
		frame_menued = index

var frame_menued = -1
func _on_frame_menu_id_pressed(id):
	if frame_menued == -1: return
	match id:
		0:
			pass
		1:
			if _FileBoss.data.frames[frame_menued] == owner.current_frame and item_count-1 > 0:
				owner.current_frame = _FileBoss.data.frames[frame_menued-1]
			_FileBoss.data.frames.remove_at(frame_menued)
			get_tree().call_group("frame_manager", "populate")
			get_tree().call_group.call_deferred("frame_bits_manager", "populate")
		2:
			_FileBoss.data.frames.append(_FileBoss.data.frames[frame_menued].duplicate(true))
			_FileBoss.data.frames[-1].name = "%s(copy)" % _FileBoss.data.frames[-1].name
			get_tree().call_group("frame_manager", "populate")
			call_deferred("select",item_count-1)
			call_deferred("_on_item_selected", item_count-1)
			get_tree().call_group.call_deferred("frame_bits_manager", "populate")


func _on_frame_menu_popup_hide():
	set_deferred("frame_menued", -1)


func _on_cur_frame_name_text_submitted(new_text):
	if not owner.current_frame: return
	owner.current_frame.name = new_text
	get_tree().call_group("frame_manager", "populate")
	for i in item_count:
		if get_item_metadata(i) == owner.current_frame:
			select(i)
			_on_item_selected(i)
			break


func _on_sort_frames_pressed():
	if not "frames" in _FileBoss.data: return
	sort_items_by_text()
	for i in item_count:
		_FileBoss.data.frames[i] = get_item_metadata(i)
	get_tree().call_group("frame_manager", "populate")
