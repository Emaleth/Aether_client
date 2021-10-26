extends KinematicBody

enum {GROUNDED, AIRBORNE, SWIMMING}

var forward_speed = 5 # m/s
var backward_speed = 5 # m/s
var side_speed = 5 # m/s
var air_speed = 5 # m/s

var jump_force = 5
var mouse_sensitivity = 0.005
var state = null
var gravity = Vector3.ZERO

onready var gravity_force = ProjectSettings.get("physics/3d/default_gravity")
onready var bullet_origin : Position3D = $Position3D
onready var bullet : PackedScene = preload("res://bullet/Bullet.tscn")
#onready var camera_rig = $CameraRig
#onready var gui = $GUI
#onready var minimap_camera = $Viewport/Spatial/MinimapCamera

var target
var mouse_target

func _ready() -> void:
	configure()
	
func _physics_process(delta: float) -> void:
	movement(delta, get_direction())
	turn_player(delta)
	define_player_state() 
	
func configure():
	state = GROUNDED
	$IK.configure(find_node("Skeleton"))
	
func movement(_delta, _direction) -> void:
	var velocity = Vector3.ZERO
	var snap = Vector3.ZERO
	match state:
		GROUNDED:
			gravity = Vector3.ZERO
			snap = -get_floor_normal()
			# Z axis
			if _direction.z < 0:
				velocity.z = _direction.z * forward_speed
			if _direction.z > 0:
				velocity.z = _direction.z * backward_speed
			# X axis
			velocity.x = _direction.x * side_speed
			# Y axix
			if _direction.y > 0 or is_on_floor() == false:
				state = AIRBORNE
			
		AIRBORNE:
			velocity.z = _direction.z * air_speed
			velocity.x = _direction.x * air_speed
			if is_on_floor(): 
				if _direction.y != 0:
					snap = Vector3.ZERO
					gravity = Vector3.UP * jump_force
				else:
					state = GROUNDED
			else:
				snap = Vector3.DOWN
				gravity += Vector3.DOWN * gravity_force * _delta

	$IK.animate(velocity)
	move_and_slide_with_snap(global_transform.basis.xform(velocity) + gravity, snap, Vector3.UP)
	
func get_direction():
	var direction = Vector3.ZERO
#	if gui.input_line.has_focus() == false:
	direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction = direction.normalized()
	direction.y = Input.get_action_strength("jump")
	
	return direction
	
func turn_player(_delta):
	var turn_amount = 0.1
	if Input.is_action_pressed("turn_left"):
		rotate_y(turn_amount)
	if Input.is_action_pressed("turn_right"):
		rotate_y(-turn_amount)
		
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("secondary_action"):
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * mouse_sensitivity)

func define_player_state():
	var player_state = {"T" : Server.client_clock, "pos" : global_transform.origin, "rot" : global_transform.basis, "hp" : 100, "max_hp" : 100}
	Server.send_player_state(player_state)
	
func check_visibility(_target) -> bool:
	if $VisibilityCheck.is_colliding():
		if $VisibilityCheck.get_collider() != _target:
			return false
		else:
			return true
	else:
		return false
		
func shoot_bullet(_ability, _target):
	if _target != null and is_instance_valid(_target) and _target.is_in_group("Enemy"):
		Server.request_bullet_test(_ability, bullet_origin.global_transform.origin, bullet_origin.global_transform.basis, _target.name)
		var b = bullet.instance()
		b.global_transform = bullet_origin.global_transform
		get_tree().root.add_child(b)
		b.conf(_target)
	
