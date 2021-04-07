extends "res://src/actors/Actor.gd"

onready var minimap_camera_remote_transform : RemoteTransform = $MiniMapCameraRT

func _ready() -> void:
	Input.set_use_accumulated_input(false)
	model = preload("res://assets/model/actors/ybot.fbx")
	$Debug.queue_free()
	conf()
	conf_gui($GUI)
	minimap_camera_remote_transform.remote_path = $GUI/MiniMap/MarginContainer/ViewportContainer/Viewport/MiniMapCamera.get_path()
	create_bone_attachments()
	
func _process(delta: float) -> void:
	get_input()
	$MiniMapCameraRT.global_transform.origin.y = 20 # fixes minimap zooming when jumping
	
func get_input():
	direction += (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")) * transform.basis.z
	direction += (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * transform.basis.x
	direction = direction.normalized()
	
	rot_direction += (Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right"))
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		gravity_vec = Vector3.UP * statistics.jump

func _unhandled_input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if not Input.is_action_pressed("pan"):
			if event is InputEventMouseMotion:
				if abs(event.relative.x) > .1: 
					rotate_y(-event.relative.x * 0.005)
		
