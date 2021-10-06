extends KinematicBody

enum {IDLE, RUN, JUMP, FALL, DEAD}

var speed = 2.8 # m/s
var jump_force = 3
var mouse_sensitivity = 0.005
var gravity_force = 9.8
var state = null
var snap = Vector3.ZERO
var jumping = false
var player_state # collection of player data to send to the server
var gravity = Vector3.ZERO

onready var bullet_origin : Position3D = $Position3D
onready var bullet : PackedScene = preload("res://bullet/Bullet.tscn")
onready var camera_rig = $CameraRig
onready var gui = $GUI
onready var minimap_camera = $Viewport/Spatial/MinimapCamera

signal get_target 

func _ready() -> void:
	configure()
	
func _physics_process(delta: float) -> void:
	get_input()
	finite_state_machine(delta, get_direction())
	define_player_state() 
	
func configure():
	state = IDLE
	gui.minimap.get_node("TextureRect").texture = minimap_camera.get_viewport().get_texture()
	connect_signals()
	$IK.configure(find_node("Skeleton"))
	
func connect_signals():
	connect("get_target", camera_rig, "aim")
	camera_rig.connect("show_aim_hint", gui, "show_tooltip")
	camera_rig.connect("new_target", self, "shoot_bullet")
	
func finite_state_machine(_delta, _direction) -> void:
	var velocity = Vector3.ZERO

	match state:
		IDLE:
			snap = -get_floor_normal()
			velocity = Vector3.ZERO
			gravity = Vector3.ZERO
			$IK.idle_animation()
			
			if jumping == true:
				state = JUMP
			if get_direction() != Vector3.ZERO:
				state = RUN
			if not is_on_floor() and velocity.y < 0:
				state = FALL
				
		RUN:
			snap = -get_floor_normal()
			velocity = _direction * speed
			gravity = Vector3.ZERO
			$IK.run_animation(velocity.length())
			
			if jumping == true:
				state = JUMP
			if not is_on_floor():
				state = FALL
			if get_direction() == Vector3.ZERO:
				state = IDLE
				
		JUMP:
			snap = Vector3.DOWN
			velocity = _direction * speed
			gravity += Vector3.DOWN * gravity_force * _delta
			if is_on_floor():
				snap = Vector3.ZERO
				gravity = Vector3.UP * jump_force
			if gravity.y < 0:
				state = FALL
			
		FALL:
			snap = Vector3.DOWN
			velocity = _direction * speed
			gravity += Vector3.DOWN * gravity_force * _delta
			jumping = false
			if is_on_floor():
				state = IDLE
				
		DEAD:
			pass
			
	move_and_slide_with_snap(velocity + gravity, snap, Vector3.UP)
	
func get_direction():
	var direction = Vector3.ZERO
	if gui.chat == false:
		direction += (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")) * global_transform.basis.z
		direction += (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * global_transform.basis.x
	direction = direction.normalized()
	
	return direction
	
func get_input():
	if Input.is_action_just_pressed("jump") and gui.chat == false:
		jumping = true
	else:
		jumping = false
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and gui.chat == false:
		if event is InputEventMouseMotion:
			if abs(event.relative.x) > .1: 
				rotate_y(-event.relative.x * mouse_sensitivity)
				
		if Input.is_action_just_pressed("primary_action"):
			emit_signal("get_target")
			
		if Input.is_action_just_pressed("secondary_action"):
			emit_signal("get_target")

func define_player_state():
	player_state = {"T" : Server.client_clock, "pos" : global_transform.origin, "rot" : global_transform.basis, "anim" : [null, null]}
	Server.send_player_state(player_state)
	
func shoot_ray(_target_position):
	bullet_origin.look_at(_target_position, bullet_origin.transform.origin.cross(_target_position))
	if $Position3D/RayCast.is_colliding():
		print_debug("Ray Target: %s" % $Position3D/RayCast.get_collider().name)
		
func shoot_bullet(_target_position):
	bullet_origin.look_at(_target_position, bullet_origin.transform.origin.cross(_target_position))
	var b = bullet.instance()
	b.global_transform = bullet_origin.global_transform
	get_tree().root.add_child(b)
	
