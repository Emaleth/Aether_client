extends KinematicBody

var speed := 7
var jump_force := 20
var gravity := -50
var snap_vector := Vector3.DOWN
var velocity := Vector3.ZERO

var mouse_sensibility : float = 0.005
var mouse_deadzone : float = 0.1

onready var interaction_area = $InteractionArea


func _physics_process(delta: float) -> void:
	move(delta)
	get_look_direction()


func _unhandled_input(event: InputEvent) -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return

	if Input.is_action_just_pressed("interact"):
		interaction_area.interact()


func get_move_direction() -> Vector3:
	var move_direction := Vector3.ZERO
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		move_direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
		move_direction = move_direction.rotated(Vector3.UP, GlobalVariables.camera_rig.rotation.y).normalized()

	return move_direction


func get_move_velocity(_mov_dir : Vector3, _delta : float) -> void:
	velocity.x = _mov_dir.x * speed
	velocity.z = _mov_dir.z * speed
	velocity.y = (gravity * _delta) if is_on_floor() else (velocity.y + (gravity * _delta))

	var just_landed := is_on_floor() and snap_vector == Vector3.ZERO
	var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump")

	if is_jumping:
		velocity.y = jump_force
		snap_vector = Vector3.ZERO
	elif just_landed:
		snap_vector = Vector3.DOWN


func move(_delta : float):
	get_move_velocity(get_move_direction(), _delta)
	move_and_slide_with_snap(velocity, snap_vector, Vector3.UP, true)


func get_look_direction():
	rotation_degrees.y = GlobalVariables.camera_rig.rotation_degrees.y



