extends SpringArm

var sensibility : float = 0.002
var deadzone : float = 0.1
var default_rotation_x : float = deg2rad(-15)


func _ready() -> void:
	rotation.x = default_rotation_x
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			if abs(event.relative.y) > deadzone:
				rotation.x -= event.relative.y * sensibility
				rotation.x = clamp(rotation.x, deg2rad(-80), deg2rad(80))

