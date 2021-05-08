extends "res://src/actors/Actor.gd"

onready var minimap_camera_remote_transform : RemoteTransform = $MiniMapCameraRT
var inv_slot_num = 20

func _ready() -> void:
	statistics.name = "Emaleth"
	statistics.race = "Necromorph"
	statistics.guild = "Empire"
	statistics.level = "69"
	statistics.title = "Ancient God"
	
#	Input.set_use_accumulated_input(false)
	model = preload("res://models/human_female.fbx")
#	$Debug.queue_free()
	conf()
	$GUI.conf(resources, minimap_camera_remote_transform)
	connect("res_mod", $GUI, "update_gui", [resources])
	load_eq()
	connect("target_lost", self, "loose_target_ui")
	make_inv()
	get_test_items()
	$GUI.configure_inv(inventory)
	$GUI.configure_eq(equipment)
	
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
	var new_target = target_list.pop_front()
	if new_target:
		if target:
			target.show_indicator(false)
			target.disconnect("res_mod", $GUI, "update_targe_info")
			$GUI.get_target_info(target, false)
			if $AttackArea.overlaps_body(target): 
				target_list.append(target)
		target = new_target
		target.connect("res_mod", $GUI, "update_targe_info", [target.resources])
		target.show_indicator(true)
		$GUI.get_target_info(target, true)
		attack()
		look_at(target.global_transform.origin, Vector3.UP) # MAKE IT A LERPED ROTATION AROUND Y AXIS

func loose_target_ui():
	if target:
		target.show_indicator(false)
		$GUI.get_target_info(target, false)

func get_test_items():
	inventory[0].item = "00001"
	inventory[2].item = "00002"
	inventory[2].quantity = 50
	inventory[3].item = "00001"
	inventory[9].item = "00003"
	inventory[9].quantity = 10
	

func make_inv():
	for i in inv_slot_num:
#		print(i)
		var slot_construct = {"item" : "",
							"quantity" : 1,
							"slot_node" : null}
		inventory[i] = slot_construct
							
