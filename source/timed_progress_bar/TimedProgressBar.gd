extends PanelContainer


onready var tween := $Tween
onready var label := $Label
onready var progress_bar := $ProgressBar

var time : float


func _ready() -> void:
	hide()
	
	
func configure(_time : float):
	time = _time
	tween.remove_all()
	tween.interpolate_property(
		progress_bar,
		"value",
		100,
		0,
		_time,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN)
	tween.start()
	show()


func _on_Tween_tween_all_completed() -> void:
	hide()


func _on_Tween_tween_step(object: Object, key: NodePath, elapsed: float, value: Object) -> void:
	label.text = str(stepify(time - elapsed, 0.1))
