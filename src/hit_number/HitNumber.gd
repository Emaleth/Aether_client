extends Spatial

onready var tween : Tween = $Tween
onready var sprite3d = $Sprite3D
onready var viewport = $Viewport
onready var label = $Viewport/Label

func _ready() -> void:
	conf(56)
	
func conf(value) -> void:
	label.text = str(value)
	sprite3d.texture = viewport.get_texture()
	tween.remove_all()
	tween.interpolate_property(
		sprite3d, 
		"transform:origin:y", 
		sprite3d.transform.origin.y, 
		sprite3d.transform.origin.y + 1, 
		1, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN
		)
	tween.start()
	yield(tween, "tween_all_completed")
	queue_free()
