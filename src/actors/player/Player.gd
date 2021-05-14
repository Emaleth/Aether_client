extends "res://src/actors/Actor.gd"

onready var minimap_camera_remote_transform : RemoteTransform = $MiniMapCameraRT

func _ready() -> void:
	statistics.name = "Emaleth"
	statistics.race = "Necromorph"
	statistics.guild = "Empire"
	statistics.level = "69"
	statistics.title = "Ancient God"
	
	model = preload("res://models/human_female.fbx")
#	$Debug.queue_free()
	conf()
	$GUI.conf(resources, minimap_camera_remote_transform)
	connect("update_resources", $GUI, "update_gui", [resources])
	load_eq()
	connect("target_lost", self, "loose_target_ui")
	get_test_items()
	$GUI.configure_inv(self)
	connect("update_inventory", $GUI, "configure_inv", [self])
	$GUI.configure_eq(self)
	connect("update_equipment", $GUI, "configure_eq", [self])
	$GUI.configure_skillbar(self)
	connect("update_skillbar", $GUI, "configure_skillbar", [self])
	
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
			target.disconnect("update_resources", $GUI, "update_targe_info")
			$GUI.get_target_info(target, false)
			if $AttackArea.overlaps_body(target): 
				target_list.append(target)
		target = new_target
		target.connect("update_resources", $GUI, "update_targe_info", [target.resources])
		target.show_indicator(true)
		$GUI.get_target_info(target, true)
		attack()
		look_at(target.global_transform.origin, Vector3.UP) # MAKE IT A LERPED ROTATION AROUND Y AXIS

func loose_target_ui():
	if target:
		target.show_indicator(false)
		$GUI.get_target_info(target, false)

func get_test_items():
	inventory[0].item = "ITEM_00000"
	inventory[0].quantity = 1
	
	inventory[1].item = "ITEM_00001"
	inventory[1].quantity = 1
	
	inventory[2].item = "ITEM_00002"
	inventory[2].quantity = 1
	
	inventory[3].item = "ITEM_00003"
	inventory[3].quantity = 1
	
	inventory[4].item = "ITEM_00004"
	inventory[4].quantity = 1
	
	inventory[5].item = "ITEM_00005"
	inventory[5].quantity = 1
	
	inventory[6].item = "ITEM_00006"
	inventory[6].quantity = 1
	
	inventory[7].item = "ITEM_00007"
	inventory[7].quantity = 1
	
	inventory[8].item = "ITEM_00008"
	inventory[8].quantity = 1
	
	inventory[9].item = "ITEM_00009"
	inventory[9].quantity = 1
	
	inventory[10].item = "ITEM_00010"
	inventory[10].quantity = 1
	
	inventory[11].item = "ITEM_00011"
	inventory[11].quantity = 1
	
	inventory[12].item = "ITEM_00012"
	inventory[12].quantity = 1
	
	inventory[13].item = "ITEM_00013"
	inventory[13].quantity = 1
	
	inventory[14].item = "ITEM_00014"
	inventory[14].quantity = 1
	
	inventory[15].item = "ITEM_00015"
	inventory[15].quantity = 1
	
	inventory[16].item = "ITEM_00016"
	inventory[16].quantity = 1
	
	inventory[17].item = "ITEM_00017"
	inventory[17].quantity = 1
	
	inventory[18].item = "ITEM_00018"
	inventory[18].quantity = 1
	
	inventory[19].item = "ITEM_00019"
	inventory[19].quantity = 1
	
	inventory[20].item = "ITEM_00020"
	inventory[20].quantity = 1
	
	inventory[21].item = "ITEM_00021"
	inventory[21].quantity = 1
	
	inventory[22].item = "ITEM_00022"
	inventory[22].quantity = 1
	
	inventory[23].item = "ITEM_00023"
	inventory[23].quantity = 100
	
	inventory[24].item = "ITEM_00024"
	inventory[24].quantity = 100
	


