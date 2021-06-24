extends "res://actors/Actor.gd"

onready var minimap_camera_remote_transform : RemoteTransform = $MiniMapCameraRT

var test_items = {
		"ITEM_00000" : 1, "ITEM_00001" : 1, "ITEM_00002" : 1, "ITEM_00003" : 1, "ITEM_00004" : 1,
		"ITEM_00005" : 2, "ITEM_00006" : 2, "ITEM_00007" : 2, "ITEM_00008" : 2, "ITEM_00009" : 1, 
		"ITEM_00010" : 1, "ITEM_00011" : 1, "ITEM_00012" : 1, "ITEM_00013" : 1, "ITEM_00014" : 1, 
		"ITEM_00015" : 1, "ITEM_00016" : 1, "ITEM_00017" : 1, "ITEM_00018" : 3, "ITEM_00019" : 1, 
		"ITEM_00020" : 999, "ITEM_00021" : 999}
		
func _ready() -> void:
	statistics.name = "Emaleth"
	statistics.race = "Necromorph"
	statistics.guild = "Empire"
	statistics.level = "69"
	statistics.title = "Ancient God"

	conf()
	$GUI.configure_minimap(minimap_camera_remote_transform)
	connect("update_target_ui", $GUI, "configure_target_resources")
	connect("update_casting_bar", $GUI, "configure_casting_bar")
	$GUI.configure_resources_panel(resources)
	connect("update_resources", $GUI, "update_resources_panel")
#	load_eq()
	anim_player = $DEBUG_AnimationPlayer
	$GUI.configure_inv(self)
	connect("update_inventory", $GUI, "configure_inv", [self])
	$GUI.configure_eq(self)
	connect("update_equipment", $GUI, "configure_eq", [self])
	$GUI.configure_quickbar(self)
	connect("update_quickbar", $GUI, "configure_quickbar", [self])
	$GUI.configure_spellbook(self)
	connect("update_spellbook", $GUI, "configure_spellbook", [self])
	for i in test_items:
		add_item_to_inventory(i, test_items.get(i))
	
func _process(_delta: float) -> void:
	get_input()
	
func get_input():
	direction = Vector3.ZERO
	direction += (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")) * transform.basis.z
	direction += (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * transform.basis.x
	direction = direction.normalized()
	
	rot_direction = (Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right"))
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jumping = true

	if Input.is_action_just_pressed("next_target"):
		get_target()
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("secondary_action"):
		if event is InputEventMouseMotion:
			if abs(event.relative.x) > .1: 
				rotate_y(-event.relative.x * 0.005)





