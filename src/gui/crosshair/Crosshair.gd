extends CenterContainer

onready var crosshair : TextureRect = $TextureRect

		
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pan"):
		crosshair.hide()
	if Input.is_action_just_released("pan"):
		crosshair.show()
		
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
