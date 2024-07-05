extends Control
var offset : Vector2 = Vector2.ZERO
func _process(_delta):
	var r = get_rect()
	var l = r.size
	l.x *= 0.5
	l.y *= 0.6667
	l += offset
	%origin.position = l

func _input(event):
	pass
