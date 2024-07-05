extends Control

var current_frame = null
var current_piece = null

func _ready():
	_FileBoss.zoom_changed.connect(_on_zoom_changed)
	
func _on_zoom_changed():
	%origin.scale = Vector2(_FileBoss.zoom, _FileBoss.zoom)
