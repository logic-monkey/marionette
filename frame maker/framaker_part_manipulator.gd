extends ReferenceRect

#TODO: replace the labels that change with linedits, for precision input.

var scale_linked : bool = true
signal part_updated

var ps: Vector2
var part_scale : Vector2 = Vector2.ONE:
	get: return ps
	set(v):
		if not is_node_ready(): await get_tree().process_frame
		var s_l_cache = scale_linked
		scale_linked = false
		ps = v
		$height/height.set_value_no_signal(convert_scale_to_normal(ps.y))
		$width/width.set_value_no_signal(convert_scale_to_normal(ps.x))
		scale_linked = s_l_cache
		refresh_scale_text()
		part_updated.emit()


func _on_hnw_link_toggled(toggled_on):
	scale_linked = toggled_on
	if toggled_on: $hnw_link.text = " | "
	else: $hnw_link.text = " : "

var last_width = 0.0
func _on_width_value_changed(value):
	if scale_linked:
		$height/height.set_value_no_signal($height/height.value + (value - last_width))
	last_width = value
	calculate_scale()
	

var last_height = 0.0
func _on_height_value_changed(value):
	if scale_linked:
		$width/width.set_value_no_signal($width/width.value + (value - last_height))
	last_height = value
	calculate_scale()

func calculate_scale():
	ps.x = convert_normal_to_scale($width/width.value)
	ps.y = convert_normal_to_scale($height/height.value)
	part_updated.emit()
	refresh_scale_text()
	
	
func refresh_scale_text():
	$width/widthlabel.text = "Width: %01.2f" % ps.x
	$height/heightlabel.text = "Height: %01.2f" % ps.y
	
func convert_normal_to_scale(value: float) -> float:
	if is_zero_approx(value): return 1.0
	if value > 0: return 1 + (clampf(value*3, 0, 3))
	value += 1.1
	return clampf(value, 0.05, 0.95)
	
func convert_scale_to_normal(value: float) -> float:
	if is_equal_approx(value, 1.0): return 0.0
	if value > 1: return clampf((value-1)/3,0,1)
	value -= 1.1
	return clampf(value,-1,0)

func _on_scale_reset_pressed():
	part_scale = Vector2.ONE
	part_rotation = 0

var ph : bool = false
var part_hflip : bool:
	get: return ph
	set(v):
		ph = v
		part_updated.emit()
func _on_hflip_toggled(toggled_on):
	part_hflip = toggled_on

var pv : bool = false
var part_vflip : bool:
	get: return pv
	set(v):
		pv = v
		part_updated.emit()
func _on_vflip_toggled(toggled_on):
	part_vflip = toggled_on

var pr : float = 0
var part_rotation: float:
	get: return pr
	set(v):
		pr = v
		$dial._set_rotation_no_signal(v)
		part_updated.emit()
func _on_dial_dial_changed(value):
	pr = value
	part_updated.emit()


var pa : float = 0
var part_alpha: float:
	get: return pa
	set(v):
		pa = v
		$alpha/alpha.set_value_no_signal(pa)
		part_updated.emit()
		refresh_alpha_text()
func _on_alpha_value_changed(value):
	pa = value
	part_updated.emit()
	refresh_alpha_text()
func refresh_alpha_text():
	$alpha/alphalabel.text = "Alpha: %01.2f" % part_alpha

var pk : float = 0
var part_skew: float:
	get: return pk
	set(v):
		pk = v
		part_updated.emit()
		refresh_skew_text()
		$skew/skew.set_value_no_signal(v)
func _on_skew_value_changed(value):
	pk = value
	part_updated.emit()
	refresh_skew_text()
func refresh_skew_text():
	$skew/Label.text = "Skew: %01.2f" % part_skew
