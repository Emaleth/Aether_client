extends Node

var collection = {}
var container = self

onready var dummy_actor_scene = preload("res://source/actor/dummy_player/dummy_player.tscn")


func _physics_process(_delta: float) -> void:
	add_to_the_tree()
	update_in_the_tree()
	remove_from_the_tree()


func add_to_the_tree():
	for pc in collection.keys():
		if pc == str(get_tree().get_network_unique_id()):
			if GlobalVariables.player_actor == null:
				get_parent().get_node("CharacterProcessor").spawn_character()
		else:
			if not container.has_node(str(pc)):
				var new_pc = dummy_actor_scene.instance()
				new_pc.name = str(pc)
				container.add_child(new_pc, true)


func update_in_the_tree():
	for pc in container.get_children():
		if collection.has(str(pc.name)):
			pc.update(collection[str(pc.name)]["t"], collection[str(pc.name)]["r"])
	if collection.has(str(get_tree().get_network_unique_id())):
		GlobalVariables.resources_data = collection[str(get_tree().get_network_unique_id())]["r"]


func remove_from_the_tree():
	for pc in container.get_children():
		if !collection.has(str(pc.name)):
			pc.queue_free()


func add_to_the_collection(_id, _data):
	collection[_id] = _data


func update_inside_the_collection(_id, _data):
	for key in _data.keys():
		collection[_id][key] = _data[key]


func remove_from_the_collection(_id):
	collection.erase(_id)


func interpolate(_render_time, world_state_buffer):
	var interpolation_factor = float(_render_time - world_state_buffer[1]["T"]) / float(world_state_buffer[2]["T"] - world_state_buffer[1]["T"])
	# PLAYERS
	for pc in world_state_buffer[2]["P"].keys():
		if not world_state_buffer[1]["P"].has(pc): # WE WANT TO BE SURE THAT BOTH WS1 AND WS2 HAVE ANY GIVEN KEY FOR INTERPOLATION'S SAKE
			continue
		if collection.has(str(pc)):
			var modified_data := {}
			modified_data = world_state_buffer[2]["P"][pc].duplicate(true)
			modified_data["t"].origin = lerp(world_state_buffer[1]["P"][pc]["t"].origin, world_state_buffer[2]["P"][pc]["t"].origin, interpolation_factor)
			var current_rot = (world_state_buffer[1]["P"][pc]["t"].basis).get_rotation_quat()
			var target_rot = (world_state_buffer[2]["P"][pc]["t"].basis).get_rotation_quat()
			modified_data["t"].basis = Basis(current_rot.slerp(target_rot, interpolation_factor))
			update_inside_the_collection(pc, modified_data)
		else:
			add_to_the_collection(pc, world_state_buffer[2]["P"][pc])
	for pc in collection:
		if not world_state_buffer[2]["P"].keys().has(pc):
			remove_from_the_collection(pc)


func extrapolate(_render_time, world_state_buffer):
	var extrapolation_factor = float(_render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.00
	# PLAYERS
	for pc in world_state_buffer[1]["P"].keys():
		if not world_state_buffer[0]["P"].has(pc): # WE WANT TO BE SURE THAT BOTH WS0 AND WS1 HAVE ANY GIVEN KEY FOR EXTRAPOLATION'S SAKE
			continue
		if collection.has(pc):
			var modified_data := {}
			var position_delta = (world_state_buffer[1]["P"][pc]["t"].origin - world_state_buffer[0]["P"][pc]["t"].origin)
			modified_data["t"] = Transform.IDENTITY
			modified_data["t"].origin = world_state_buffer[1]["P"][pc]["t"].origin + (position_delta * extrapolation_factor)
			var current_rot = (world_state_buffer[1]["P"][pc]["t"].basis).get_rotation_quat()
			var old_rot = (world_state_buffer[0]["P"][pc]["t"].basis).get_rotation_quat()
			var rotation_delta = (current_rot - old_rot)
			modified_data["t"].basis = Basis(current_rot + (rotation_delta * extrapolation_factor))
			update_inside_the_collection(pc, modified_data)

