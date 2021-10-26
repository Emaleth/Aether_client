extends PanelContainer

export(Color) var color 
export(bool) var show_percentage
export(bool) var show_value

var max_value := 0
var value := 0

onready var progress_bar := $ProgressBar
onready var progress_label := $Label
onready var tween := $Tween


func update_ui(_max_value, _value):
	if _max_value == max_value:
		update_component(_value)
	else:
		configure_component(_max_value, _value)
		
func configure_component(_max_value, _value):
	max_value = _max_value
	value = _value
	var new_fg = StyleBoxFlat.new()
	new_fg.bg_color = color
	progress_bar.set("custom_styles/fg", new_fg) 
	tween.connect("tween_step", self, "apply_update")
	apply_update()

func apply_update(_o = null, _k = null, _e = null, _v = null):
	# PROGRESS BAR
	progress_bar.value = value
	# LABEL
	var value_text := ""
	var percentage_text := ""
	if show_value:
		value_text = "%s/%s" % [value, max_value]
	if show_percentage and show_value:
		percentage_text = " (%s%%)" % (value / (max_value / 100))
	if show_percentage and not show_value:
		percentage_text = "%s%%" % (value / (max_value / 100))
	progress_label.text = "%s%s" % [value_text, percentage_text]
	
func update_component(_value):
	var animation_time = 0.5
	tween.remove_all()
	tween.interpolate_property(self, "value", value, _value, animation_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _on_Button_pressed() -> void:
	update_ui(100, rand_range(0, 100))
