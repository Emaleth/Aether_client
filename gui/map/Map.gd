extends PanelContainer


onready var camera : Camera = $ViewportContainer/Viewport/Camera

func _ready() -> void:
	camera.global_transform.origin = Vector3(0, 50, 0)
