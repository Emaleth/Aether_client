extends MarginContainer


onready var camera : Camera = $MarginContainer/ViewportContainer/Viewport/Camera

func _ready() -> void:
	camera.global_transform.origin = Vector3(0, 50, 0)
