extends Node

var fialogue : FileDialog
var fialogueMode : int = -1

var data = {}
var images = {}
#var visible_rects = []
signal zoom_changed
var zoom = 1.0 :
	get: return zoom
	set(v):
		v = clampf(v,0.1,100)
		zoom = v
		zoom_changed.emit()
