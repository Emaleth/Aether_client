extends "res://src/actors/Actor.gd"

onready var minimap_camera_remote_transform : RemoteTransform = $MiniMapCameraRT


func _ready() -> void:
#	Input.set_use_accumulated_input(false)
	model = preload("res://assets/model/actors/ybot.fbx")
	$Debug.queue_free()
	conf()
	$GUI.conf(resources, minimap_camera_remote_transform)
	equip_item((preload("res://assets/model/weapons/sword.fbx")).instance())
	
func _process(delta: float) -> void:
	get_input()
	$GUI.nesw.rect_rotation = rotation_degrees.y
	
func get_input():
	direction = Vector3.ZERO
	direction += (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")) * transform.basis.z
	direction += (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * transform.basis.x
	direction = direction.normalized()
	
	rot_direction = (Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right"))
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jumping = true

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("secondary_action"):
		if event is InputEventMouseMotion:
			if abs(event.relative.x) > .1: 
				rotate_y(-event.relative.x * 0.005)
		
