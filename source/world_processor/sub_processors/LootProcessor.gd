extends Node

var pc_collection = {}

onready var pc_container = self

onready var dummy_actor_scene = preload("res://source/actor/dummy_actor/dummy_actor.tscn")


#func _physics_process(_delta: float) -> void:
#	add_pc_to_the_tree()
#	update_pc_in_the_tree()
#	remove_pc_from_the_tree()

	
func add_pc_to_the_tree():
	for pc in pc_collection.keys():
		if pc == str(get_tree().get_network_unique_id()):
			if GlobalVariables.player_actor == null:
				get_parent().get_node("CharacterProcessor").spawn_character()
		else:
			if not pc_container.has_node(str(pc)):
				var new_pc = dummy_actor_scene.instance()
				new_pc.name = str(pc)
				pc_container.add_child(new_pc, true)
	
	
func update_pc_in_the_tree():
	for pc in pc_container.get_children():
		if pc_collection.has(str(pc.name)):
			pc.update(pc_collection[str(pc.name)]["pos"], pc_collection[str(pc.name)]["rot"], pc_collection[str(pc.name)]["res"])
	if pc_collection.has(str(get_tree().get_network_unique_id())):
		GlobalVariables.resources_data = pc_collection[str(get_tree().get_network_unique_id())]["res"]


func remove_pc_from_the_tree():
	for pc in pc_container.get_children():
		if !pc_collection.has(str(pc.name)):
			pc.queue_free()
	

func add_pc_to_the_collection(_id, _data):
	pc_collection[_id] = _data


func update_pc_inside_the_collection(_id, _data):
	for key in _data.keys():
		pc_collection[_id][key] = _data[key]


func remove_pc_from_the_collection(_id):
	pc_collection.erase(_id)

	
func interpolate(_render_time, world_state_buffer):
	var interpolation_factor = float(_render_time - world_state_buffer[1]["T"]) / float(world_state_buffer[2]["T"] - world_state_buffer[1]["T"])
	# PLAYERS
	for pc in world_state_buffer[2]["P"].keys():
		if not world_state_buffer[1]["P"].has(pc): # WE WANT TO BE SURE THAT BOTH WS1 AND WS2 HAVE ANY GIVEN KEY FOR INTERPOLATION'S SAKE
			continue
		if pc_collection.has(str(pc)):
			var modified_data := {}
			modified_data = world_state_buffer[2]["P"][pc].duplicate(true)
			modified_data["pos"] = lerp(world_state_buffer[1]["P"][pc]["pos"], world_state_buffer[2]["P"][pc]["pos"], interpolation_factor)
			var current_rot = (world_state_buffer[1]["P"][pc]["rot"]).get_rotation_quat()
			var target_rot = (world_state_buffer[2]["P"][pc]["rot"]).get_rotation_quat()
			modified_data["rot"] = Basis(current_rot.slerp(target_rot, interpolation_factor))
			update_pc_inside_the_collection(pc, modified_data)
		else:
			add_pc_to_the_collection(pc, world_state_buffer[2]["P"][pc])
	for pc in pc_collection:
		if not world_state_buffer[2]["P"].keys().has(pc):
			remove_pc_from_the_collection(pc)
			
	
func extrapolate(_render_time, world_state_buffer):
	var extrapolation_factor = float(_render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.00
	# PLAYERS
	for pc in world_state_buffer[1]["P"].keys():
		if not world_state_buffer[0]["P"].has(pc): # WE WANT TO BE SURE THAT BOTH WS0 AND WS1 HAVE ANY GIVEN KEY FOR EXTRAPOLATION'S SAKE
			continue
		if pc_collection.has(pc):
			var modified_data := {}
			var position_delta = (world_state_buffer[1]["P"][pc]["pos"] - world_state_buffer[0]["P"][pc]["pos"]) 
			modified_data["pos"] = world_state_buffer[1]["P"][pc]["pos"] + (position_delta * extrapolation_factor)
			var current_rot = (world_state_buffer[1]["P"][pc]["rot"]).get_rotation_quat()
			var old_rot = (world_state_buffer[0]["P"][pc]["rot"]).get_rotation_quat()
			var rotation_delta = (current_rot - old_rot) 
			modified_data["rot"] = Basis(current_rot + (rotation_delta * extrapolation_factor))
			update_pc_inside_the_collection(pc, modified_data)

