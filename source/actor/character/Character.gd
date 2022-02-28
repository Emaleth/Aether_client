extends KinematicBody

var speed := 7
var jump_force := 12
var gravity := -45
var snap_vector := Vector3.DOWN
var velocity := Vector3.ZERO

var mouse_sensibility : float = 0.005
var mouse_deadzone : float = 0.1


func _physics_process(delta: float) -> void:
	move(delta)
	if $CameraRig.target_data.size() > 0: aim($CameraRig.target_data) 
	

func _unhandled_input(event: InputEvent) -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if GlobalVariables.chatting:
		return
	if event is InputEventMouseMotion:
		rotate_camera_rig(event.relative)


func get_move_direction() -> Vector3:
	var move_direction := Vector3.ZERO
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and GlobalVariables.chatting == false and GlobalVariables.user_interface.mode == GlobalVariables.user_interface.COMBAT:
		move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		move_direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
		move_direction = move_direction.rotated(Vector3.UP, rotation.y).normalized()

	return move_direction


func get_move_velocity(_mov_dir : Vector3, _delta : float) -> void:
	velocity.x = _mov_dir.x * speed
	velocity.z = _mov_dir.z * speed
	velocity.y = (gravity * _delta) if is_on_floor() else (velocity.y + (gravity * _delta))

	var just_landed := is_on_floor() and snap_vector == Vector3.ZERO
	var ui_mode_check := true if GlobalVariables.user_interface.mode == GlobalVariables.user_interface.COMBAT else false
	var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump") and GlobalVariables.chatting == false and ui_mode_check

	if is_jumping:
		velocity.y = jump_force
		snap_vector = Vector3.ZERO
	elif just_landed:
		snap_vector = Vector3.DOWN


func move(_delta : float):
	get_move_velocity(get_move_direction(), _delta)
	move_and_slide_with_snap(velocity, snap_vector, Vector3.UP, true)


func rotate_camera_rig(_amount : Vector2) -> void:
	if _amount.length() <= mouse_deadzone:
		return
	rotation.y -= _amount.x * mouse_sensibility
	rotation.y = wrapf(rotation.y, -180, 180)


func aim(target_data):
	$gun.look_at(target_data.position, Vector3.UP)
