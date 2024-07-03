extends PopupMenu

func _on_about_to_popup():
	var vp_rect = get_viewport().get_visible_rect()
	var this_rect = Rect2(position, size)
	if not vp_rect.encloses(this_rect):
		if position.x < 0: position.x = 0
		if position.y < 0: position.y = 0
		if position.x + size.x > vp_rect.size.x:
			position.x = vp_rect.size.x-size.x
		if position.y + size.y > vp_rect.size.y:
			position.y = vp_rect.size.y-size.y
