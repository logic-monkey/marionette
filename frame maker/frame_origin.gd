extends Marker2D

@export 
var crosshair_scale : float = 144

func _draw():
	draw_line(Vector2(-crosshair_scale,0),Vector2(crosshair_scale,0),Color(1.0,1.0,0.0,1.0),-1.0)
	draw_line(Vector2(0,-crosshair_scale),Vector2(0,crosshair_scale),Color(1.0,1.0,0.0,1.0),-1.0)
	var s = crosshair_scale * 0.5
	draw_rect(Rect2(-s,-s,crosshair_scale,crosshair_scale),Color(1.0,1.0,0.0,1.0),false,-1.0)
	pass
