extends Control

onready var bar : ProgressBar = $ProgressBar
onready var tween : Tween = $Tween

func conf(time : float) -> void:
	var fg = bar.get("custom_styles/fg").duplicate()
	fg.bg_color = Color.purple
	bar.set("custom_styles/fg", fg)
	show()
	tween.remove_all()
	tween.interpolate_property(
		bar, 
		"value", 
		0, 
		100, 
		time, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN
		)
	tween.start()
	yield(tween,"tween_all_completed")
	hide()
