extends SpringArm

var sensibility : float = 0.005
var deadzone : float = 0.1
var min_rotation_x : float = deg2rad(-80)
var max_rotation_x : float = deg2rad(80)


onready var camera = $Camera


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
func _unhandled_input(event: InputEvent) -> void:
	if not Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		return
	if event is InputEventMouseMotion:
		rotate_camera_rig(event.relative)

		
func rotate_camera_rig(_amount : Vector2) -> void:
	if _amount.length() <= deadzone:
		return
	rotation.x -= _amount.y * sensibility
	rotation.x = clamp(rotation.x, min_rotation_x, max_rotation_x)
	

func cast_ray_from_camera_to_mouse_pointer() -> Dictionary:
	var space_state = get_world().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	var ray_length = 1000
	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * ray_length
	var intersection = space_state.intersect_ray(from, to)
	return intersection
