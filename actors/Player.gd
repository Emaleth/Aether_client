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

var player_state # collection of player data to send to the server
# CAMERA BEGIN
var sensibility : float = 0.002
var deadzone : float = 0.1
var default_rotation_x : float = deg2rad(-15)
# CAMERA END
onready var bullet_origin : Position3D = $Position3D
onready var bullet : PackedScene = preload("res://bullet/Bullet.tscn")
onready var ray : RayCast = $CameraRig/Camera/RayCast
onready var anim : AnimationPlayer = $Male_Casual/AnimationPlayer
onready var camera_rig = $CameraRig


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera_rig.rotation.x = default_rotation_x
	state = IDLE
	
func _physics_process(delta: float) -> void:
	get_input()
	finite_state_machine(delta, get_direction())
	define_player_state()
	
	
func finite_state_machine(delta: float, direction) -> void:
	match state:
		IDLE:
			anim.play("Man_Idle")
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
			anim.play("Man_Walk")
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
			anim.play("Man_Run")
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
			anim.play("Man_Run")
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
			anim.play("Man_Jump")
			snap = Vector3.DOWN
			velocity = velocity.linear_interpolate(direction * air_speed, acceleration * delta)
			gravity += Vector3.DOWN * gravity_force * delta
			if is_on_floor():
				snap = Vector3.ZERO
				gravity = Vector3.UP * jump_force
			if gravity.y < 0:
				state = FALL
			
		FALL:
			anim.play("Man_Run")
			snap = Vector3.DOWN
			velocity = velocity.linear_interpolate(direction * air_speed, acceleration * delta)
			gravity += Vector3.DOWN * gravity_force * delta
			jumping = false
			if is_on_floor():
				state = IDLE
				
		DEAD:
			anim.play("Man_Run")
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
			if abs(event.relative.y) > deadzone:
				camera_rig.rotation.x -= event.relative.y * sensibility
				camera_rig.rotation.x = clamp(camera_rig.rotation.x, deg2rad(-80), deg2rad(80))

		if event is InputEventMouseMotion:
			if abs(event.relative.x) > .1: 
				rotate_y(-event.relative.x * mouse_sensitivity)
				
		if Input.is_action_just_pressed("primary_action"):
			if ray.is_colliding():
				print_debug(ray.get_collider().name + "_PrimaryA")
			else:
				print_debug("no ray collision")
		if Input.is_action_just_pressed("secondary_action"):
			shoot()
#			if ray.is_colliding():
#				print_debug(ray.get_collider().name + "_SecondaryA")
			
func define_player_state():
	player_state = {"T" : Server.client_clock, "pos" : global_transform.origin, "rot" : global_transform.basis, "anim" : [anim.current_animation, anim.current_animation_position]}
	Server.send_player_state(player_state)
	
func shoot():
	if not ray.is_colliding():
		return
	bullet_origin.look_at(ray.get_collision_point(), Vector3.UP)
	var b = bullet.instance()
	b.global_transform = bullet_origin.global_transform
	get_tree().root.add_child(b)
	
