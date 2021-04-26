extends "res://src/actors/Actor.gd"

onready var minimap_camera_remote_transform : RemoteTransform = $MiniMapCameraRT


func _ready() -> void:
	statistics.name = "Emaleth"
	statistics.race = "Necromorph"
	statistics.guild = "Empire"
	
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

	if Input.is_action_just_pressed("next_target"):
		get_next_target()
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("secondary_action"):
		if event is InputEventMouseMotion:
			if abs(event.relative.x) > .1: 
				rotate_y(-event.relative.x * 0.005)
		
func get_next_target():
	target_list = []
	for i in $AttackArea.get_overlapping_bodies():
		if i != self:
			if i is KinematicBody:
				target_list.append(i)
				print(i)
	var new_target = target_list.pop_front()
	if new_target:
		if target:
			target.show_indicator(false)
			$GUI.get_target_info(target, false)
		target = new_target
		target.show_indicator(true)
		$GUI.get_target_info(target, true)
