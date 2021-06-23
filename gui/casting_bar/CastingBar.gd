extends Control

onready var tween : Tween = $Tween
onready var timer_label = $Label

var cast_time_text = 0
func conf(time : float) -> void:
	var fg = get("custom_styles/fg").duplicate()
	fg.bg_color = Color.purple
	set("custom_styles/fg", fg)
	cast_time_text = time
	show()
	tween.remove_all()
	tween.interpolate_property(
		self, 
		"value", 
		0, 
		100, 
		time, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN
		)
		
	tween.interpolate_property(
		self, 
		"cast_time_text", 
		cast_time_text, 
		0, 
		time, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN
		)
		
		
	tween.start()
	yield(tween,"tween_all_completed")
	hide()

func _on_Tween_tween_step(_object: Object, _key: NodePath, _elapsed: float, _value: Object) -> void:
	timer_label.text = str(stepify(cast_time_text, 0.1))
