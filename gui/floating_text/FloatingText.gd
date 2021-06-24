extends Spatial

onready var tween : Tween = $Tween
onready var mesh = $MeshInstance
onready var viewport = $Viewport
onready var label = $Viewport/Label
	
func conf(value, color) -> void:
	label.text = str(value)
	label.self_modulate = color
	tween.remove_all()
	tween.interpolate_property(
		mesh, 
		"transform:origin:y", 
		mesh.transform.origin.y, 
		mesh.transform.origin.y + 1, 
		1, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN
		)
	tween.start()
	yield(tween, "tween_all_completed")
	queue_free()
