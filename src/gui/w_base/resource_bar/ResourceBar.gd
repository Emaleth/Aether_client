extends HBoxContainer

var step_time : float # time to modify progress by 1 

onready var res_label : Label = $Label
onready var res_bar : ProgressBar = $ProgressBar
onready var res_tween : Tween = $Tween


func conf(res_name : String, res_max : int, res_current : int, fg_color : Color, st : float = 0.01) -> void:
	res_label.text = res_name
	res_bar.max_value = res_max
	res_bar.value = res_current
	step_time = st
	# make style resource unique as to use different colours
	var fg = res_bar.get("custom_styles/fg").duplicate()
	fg.bg_color = fg_color
	res_bar.set("custom_styles/fg", fg)
	
func updt(res_current : int) -> void:
	res_tween.remove_all()
	res_tween.interpolate_property(
		res_bar, 
		"value", 
		res_bar.value, 
		res_current, 
		abs(res_bar.value - res_current) * step_time, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN
		)
	res_tween.start()
	