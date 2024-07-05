extends Control

var current_image = ""

func _ready():
	get_viewport().size_changed.connect(queue_redraw)

func _draw():
	var pos = %current_image.get_global_rect().position - get_global_rect().position
	#draw_circle(pos, 5, Color.RED)
	if not "images" in _FileBoss.data: return
	if current_image.is_empty(): return
	if not "slices" in _FileBoss.data.images[current_image]: return
	for slice in _FileBoss.data.images[current_image].slices:
		var r = slice.rect as Rect2
		r.position *= _FileBoss.zoom
		r.size *= _FileBoss.zoom
		r.position += pos
		draw_rect(r, Color(0.0,0.0,0.0,0.25), false, 1.0)
		draw_rect(r, Color(1.0,1.0,0.0,0.5), false, 1.0)
		
func _notification(what):
	if what == NOTIFICATION_WM_SIZE_CHANGED:
		queue_redraw()
