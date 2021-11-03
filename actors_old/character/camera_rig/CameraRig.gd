extends SpringArm

var sensibility : float = 0.005
var deadzone : float = 0.1
var default_rotation_x : float = deg2rad(-45)
var min_rotation_x : float = deg2rad(-80)
var max_rotation_x : float = deg2rad(80)
var default_rotation_y : float = deg2rad(0)
var default_spring_lenght = 15
var zoom_sensibility = 0.5
var max_spring_leght = 20
var min_spring_leght = 3

onready var camera = $Camera

signal move_to_position


func _ready() -> void:
	set_defaults()

func set_defaults():
	rotation.x = default_rotation_x
	rotation.y = default_rotation_y
	spring_length = default_spring_lenght
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("click"):
		get_move_position()
		
	if Input.is_action_pressed("rotate_camera"):
		if event is InputEventMouseMotion:
			rotate_camera_rig(event.relative)
			
	if Input.is_action_just_pressed("rotate_camera"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	elif Input.is_action_just_released("rotate_camera"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_just_pressed("zoom_in"):
		spring_length = max(spring_length - zoom_sensibility, min_spring_leght)
		
	elif Input.is_action_just_pressed("zoom_out"):
		spring_length = min(spring_length + zoom_sensibility, max_spring_leght)
		
func rotate_camera_rig(_amount : Vector2) -> void:
	if _amount.length() <= deadzone:
		return
	rotation.x -= _amount.y * sensibility
	rotation.x = clamp(rotation.x, min_rotation_x, max_rotation_x)
	rotation.y -= _amount.x * sensibility

func get_move_position():
	var intersection = cast_ray_from_camera_to_mouse_pointer()
	if intersection.empty():
		return
	else:
		emit_signal("move_to_position", intersection.position)
		Server.send_movement_request(intersection.position)
		
func get_action_target():
	var intersection = cast_ray_from_camera_to_mouse_pointer()
	if intersection.empty():
		return null
	else:
		return intersection.collider

func cast_ray_from_camera_to_mouse_pointer() -> Dictionary:
	var space_state = get_world().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	var ray_length = 1000
	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * ray_length
	var intersection = space_state.intersect_ray(from, to)
	return intersection
