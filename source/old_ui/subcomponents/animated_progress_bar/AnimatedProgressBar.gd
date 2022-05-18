extends PanelContainer

export(Color) var color 
export(bool) var show_percentage
export(bool) var show_value

var max_value := 0.0
var value := 0.0
var new_value := 0.0

onready var progress_bar := $ProgressBar
onready var progress_label := $Label
onready var tween := $Tween


func update_ui(_value, _max_value):
	if _max_value == max_value:
		if new_value != _value:
			update_component(float(_value))
	else:
		configure_component(float(_max_value), float(_value))
		
func configure_component(_max_value, _value):
	max_value = _max_value
	value = _value
#	var new_fg = StyleBoxFlat.new()
	var new_fg = progress_bar.get("custom_styles/fg").duplicate()
	new_fg.bg_color = color
	progress_bar.set("custom_styles/fg", new_fg) 
	apply_update()

func apply_update():
	# PROGRESS BAR
	progress_bar.value = value
	progress_bar.max_value = max_value
	# LABEL
	var value_text := ""
	var percentage_text := ""
	if show_value:
		value_text = "%s/%s" % [int(value), int(max_value)]
	if show_percentage and show_value:
		percentage_text = " (%s%%)" % int(value / (max_value / 100.0))
	if show_percentage and not show_value:
		percentage_text = "%s%%" % int(value / (max_value / 100.0))
	progress_label.text = "%s%s" % [value_text, percentage_text]
	
func update_component(_value):
	new_value = _value
	var animation_time = 0.5
	tween.stop_all()
	tween.remove_all()
	tween.interpolate_property(self, "value", value, _value, animation_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func set_hud_font(_font):
	$Label.set("custom_fonts/font", _font)

func _on_Tween_tween_step(_object: Object, _key: NodePath, _elapsed: float, _value: Object) -> void:
	apply_update()
