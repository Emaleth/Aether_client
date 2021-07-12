extends KinematicBody

enum {IDLE, WALK, RUN, SPRINT, JUMP, FALL, DEAD}
# player variables
var walk_speed = 5
var run_speed = 10
var air_speed = 7
var sprint_speed = 15
var acceleration = 10
var deceleration = 30
var jump_force = 20
# game / environment variable
var mouse_sensitivity = 0.005
var gravity_force = 50
# internal variables
var state = null
var snap = Vector3.ZERO
var velocity = Vector3.ZERO
var gravity = Vector3.ZERO
var movement = Vector3.ZERO
var jumping = false
var walking = false
var sprinting = false

onready var gui = preload("res://gui/GUI.tscn")
onready var indicator = preload("res://gui/actor_indicator/ActorIndicator.tscn")
onready var camera_rig = preload("res://actors/CameraRig.tscn")
onready var minimap_camera_anchor = preload("res://actors/MinimapCameraAnchor.tscn")


func _ready() -> void:
	conf()
	
func _physics_process(delta: float) -> void:
	get_input()
	finite_state_machine(delta, get_direction())
		
func conf():
	# ADD GUI, INDICATOR, CAMERA RIG AND MINIMAP CAMERA ANCHOR
	gui = gui.instance()
	add_child(gui)
	indicator = indicator.instance()
	add_child(indicator)
	camera_rig = camera_rig.instance()
	add_child(camera_rig)
	minimap_camera_anchor = minimap_camera_anchor.instance()
	add_child(minimap_camera_anchor)
	minimap_camera_anchor.conf(gui.get_minimap_camera_path())
	# SET INITIAL STATE AS IDLE
	state = IDLE
	
func finite_state_machine(delta: float, direction) -> void:
	match state:
		IDLE:
			snap = -get_floor_normal()
			velocity = velocity.linear_interpolate(Vector3.ZERO, deceleration * delta)
			gravity = Vector3.ZERO
			
			if jumping == true:
				state = JUMP
			if get_direction() != Vector3.ZERO:
				if sprinting == true:
					state = SPRINT
				elif walking == true:
					state = WALK
				else:
					state = RUN
			if not is_on_floor() and velocity.y < 0:
				state = FALL
				
		WALK:
			snap = -get_floor_normal()
			velocity = velocity.linear_interpolate(direction * walk_speed, acceleration * delta)
			gravity = Vector3.ZERO
			
			if jumping == true:
				state = JUMP
			if not is_on_floor():
				state = FALL
			if get_direction() == Vector3.ZERO:
				state = IDLE
			else:
				if walking == false:
					state = RUN
			
		RUN:
			snap = -get_floor_normal()
			velocity = velocity.linear_interpolate(direction * run_speed, acceleration * delta)
			gravity = Vector3.ZERO
			
			if jumping == true:
				state = JUMP
			if sprinting == true:
				state = SPRINT
			if walking == true:
				state = WALK
			if not is_on_floor():
				state = FALL
			if get_direction() == Vector3.ZERO:
				state = IDLE
				
		SPRINT:
			snap = -get_floor_normal()
			velocity = velocity.linear_interpolate(direction * sprint_speed, acceleration * delta)
			gravity = Vector3.ZERO
			
			if jumping == true:
				state = JUMP
			if get_direction() == Vector3.ZERO:
				state = IDLE
			else:
				if sprinting == false:
					state = RUN
			if not is_on_floor():
				state = FALL
			
		JUMP:
			snap = Vector3.DOWN
			velocity = velocity.linear_interpolate(direction * air_speed, acceleration * delta)
			gravity += Vector3.DOWN * gravity_force * delta
			if is_on_floor():
				snap = Vector3.ZERO
				gravity = Vector3.UP * jump_force
			if gravity.y < 0:
				state = FALL
			
		FALL:
			snap = Vector3.DOWN
			velocity = velocity.linear_interpolate(direction * air_speed, acceleration * delta)
			gravity += Vector3.DOWN * gravity_force * delta
			jumping = false
			if is_on_floor():
				state = IDLE
				
		DEAD:
			pass
			
	movement = velocity + gravity
	move_and_slide_with_snap(movement, snap, Vector3.UP)
	
func get_direction():
	var direction = Vector3.ZERO
	direction += (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")) * global_transform.basis.z
	direction += (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * global_transform.basis.x
	direction = direction.normalized()
	
	return direction
	
func get_input():
	if Input.is_action_pressed("jump"):
		jumping = true
	else:
		jumping = false

	if Input.is_action_pressed("walk"):
		walking = true
	else:
		walking = false
		
	if Input.is_action_pressed("sprint"):
		sprinting = true
	else:
		sprinting = false
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			if abs(event.relative.x) > .1: 
				rotate_y(-event.relative.x * mouse_sensitivity)

