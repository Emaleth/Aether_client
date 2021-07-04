extends KinematicBody

enum {IDLE, RUN, JUMP, FALL, DEAD}

var speed = 10
var acceleration = 10
var state = null
var velocity = Vector3()
var gravity = (9.8 * Vector3.DOWN)
var jumping = false

onready var gui = preload("res://gui/GUI.tscn")
onready var indicator = preload("res://gui/actor_indicator/ActorIndicator.tscn")
onready var camera_rig = preload("res://actors/CameraRig.tscn")
onready var minimap_camera_anchor = preload("res://actors/MinimapCameraAnchor.tscn")

func _ready() -> void:
	conf()
	
func _physics_process(delta: float) -> void:
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
	var velocity_vector = Vector3.ZERO
	var gravity_vector = Vector3.ZERO
	match state:
		IDLE:
			pass
#
		RUN:
			pass
			
		JUMP:
			pass
			
		FALL:
			pass
			
		DEAD:
			pass
			
	velocity = move_and_slide(velocity, Vector3.UP, true)

func get_direction():
	var direction = Vector3.ZERO
	direction += (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")) * transform.basis.z
	direction += (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * transform.basis.x
	direction = direction.normalized()
	
	return direction
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jumping = true
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			if abs(event.relative.x) > .1: 
				rotate_y(-event.relative.x * 0.005)

