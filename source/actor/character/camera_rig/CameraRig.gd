extends SpringArm

var mouse_sensibility : float = 0.005
var mouse_deadzone : float = 0.1

var min_rotation_x : float = deg2rad(-80)
var max_rotation_x : float = deg2rad(80)
var raycast_lenght := 10000

onready var camera = $Camera


func _ready() -> void:
	GlobalVariables.camera_rig = self
	set_as_toplevel(true)


func _unhandled_input(event: InputEvent) -> void:
	if not Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		return
	if event is InputEventMouseMotion:
		rotate_camera_rig(event.relative)


func rotate_camera_rig(_amount : Vector2) -> void:
	if _amount.length() <= mouse_deadzone:
		return
	rotation.x -= _amount.y * mouse_sensibility
	rotation.x = clamp(rotation.x, min_rotation_x, max_rotation_x)

	rotation.y -= _amount.x * mouse_sensibility
	rotation.y = wrapf(rotation.y, -180, 180)


func cast_ray_from_camera_to_mouse_pointer() -> Dictionary:
	var space_state = get_world().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * raycast_lenght
	var intersection = space_state.intersect_ray(from, to)

	return intersection
