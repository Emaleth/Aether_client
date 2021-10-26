extends SpringArm

var sensibility : float = 0.002
var deadzone : float = 0.1
var default_rotation_x : float = deg2rad(-15)
var min_rotation_x : float = deg2rad(-80)
var max_rotation_x : float = deg2rad(0)
var default_rotation_y : float = deg2rad(0)
var default_spring_lenght = 15
var zoom_sensibility = 0.5
var max_spring_leght = 20
var min_spring_leght = 5
var spring_back = true
var spring_back_weight = 0.5

var target = null

signal mouse_target

func _ready() -> void:
	rotation.x = default_rotation_x
	rotation.y = default_rotation_y
	spring_length = default_spring_lenght
	
func _physics_process(_delta: float) -> void:
	if spring_back == true:
		rotation.x = lerp(rotation.x, default_rotation_x, spring_back_weight)
		rotation.y = lerp(rotation.y, default_rotation_y, spring_back_weight)
		
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("primary_action"):
		get_mouse_target()
	if Input.is_action_pressed("mouse_middle"):
		spring_back = false
		if event is InputEventMouseMotion:
			rotate_camera_rig(event.relative, false)
			
	if Input.is_action_just_released("mouse_middle"):
		spring_back = true
		
	if Input.is_action_pressed("secondary_action"):
		if event is InputEventMouseMotion:
			rotate_camera_rig(event.relative, true)
			
	if Input.is_action_just_pressed("zoom_in"):
		spring_length = clamp(spring_length - zoom_sensibility, min_spring_leght, max_spring_leght)
		
	elif Input.is_action_just_pressed("zoom_out"):
		spring_length = clamp(spring_length + zoom_sensibility, min_spring_leght, max_spring_leght)
		
func rotate_camera_rig(_amount : Vector2, stable) -> void:
	if _amount.length() <= deadzone:
		return
	rotation.x -= _amount.y * sensibility
	rotation.x = clamp(rotation.x, min_rotation_x, max_rotation_x)
	rotation.y -= _amount.x * sensibility
	
	if stable:
		default_rotation_x = rotation.x
		default_rotation_y = rotation.y

func get_mouse_target():
	var new_target = null
	var space_state = get_world().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	var ray_length = 1000
	var camera = $Camera
	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * ray_length
	var intersection = space_state.intersect_ray(from, to)
	if intersection.empty():
		new_target = null
	else:
		new_target = intersection.collider
	if target != new_target:
		if target != null:
			if is_instance_valid(target):
				if target.has_method("target"):
					target.target(false)
		if new_target != null:
			if is_instance_valid(new_target):
				if new_target.has_method("target"):
					new_target.target(true)
		target = new_target
	emit_signal("mouse_target", target)
