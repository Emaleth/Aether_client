extends Spatial

onready var tween : Tween = $Tween
onready var mesh = $MeshInstance
onready var viewport = $MeshInstance/Viewport
onready var label = $MeshInstance/Viewport/Label

func _ready() -> void:
	conf(56)
	
func conf(value) -> void:
	label.text = str(value)
	mesh.get("material/0").albedo_texture = viewport.get_texture()
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
