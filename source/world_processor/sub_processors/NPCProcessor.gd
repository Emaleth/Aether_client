extends Node

var collection = {}
var container = self

onready var dummy_actor_scene = preload("res://source/actor/dummy_actor/dummy_actor.tscn")


func _physics_process(_delta: float) -> void:
	add_to_the_tree()
	update_in_the_tree()
	remove_from_the_tree()


func add_to_the_tree():
	for npc in collection.keys():
		if not container.has_node(str(npc)):
			var new_npc = dummy_actor_scene.instance()
			new_npc.name = str(npc)
			container.call_deferred("add_child", new_npc, true)


func update_in_the_tree():
	for npc in container.get_children():
		if collection.has(str(npc.name)):
			npc.update(collection[str(npc.name)]["pos"], collection[str(npc.name)]["rot"], collection[str(npc.name)]["res"])


func remove_from_the_tree():
	for npc in container.get_children():
		if not collection.has(str(npc.name)):
			npc.call_deferred("queue_free")


func add_to_the_collection(_id, _data):
	collection[_id] = _data


func update_inside_the_collection(_id, _data):
	for key in _data.keys():
		collection[_id][key] = _data[key]


func remove_from_the_collection(_id):
	collection.erase(_id)


func interpolate(_render_time, world_state_buffer):
	var interpolation_factor = float(_render_time - world_state_buffer[1]["T"]) / float(world_state_buffer[2]["T"] - world_state_buffer[1]["T"])

	for npc in world_state_buffer[2]["E"].keys():
		if not world_state_buffer[1]["E"].has(npc): # WE WANT TO BE SURE THAT BOTH WS1 AND WS2 HAVE ANY GIVEN KEY FOR INTERPOLATION'S SAKE
			continue
		if collection.has(npc):
			var modified_data := {}
			modified_data = world_state_buffer[2]["E"][npc].duplicate(true)
			modified_data["pos"] = lerp(world_state_buffer[1]["E"][npc]["pos"], world_state_buffer[2]["E"][npc]["pos"], interpolation_factor)
			var current_rot = (world_state_buffer[1]["E"][npc]["rot"]).get_rotation_quat()
			var target_rot = (world_state_buffer[2]["E"][npc]["rot"]).get_rotation_quat()
			modified_data["rot"] = Basis(current_rot.slerp(target_rot, interpolation_factor))
			update_inside_the_collection(npc, modified_data)
		else:
			add_to_the_collection(npc, world_state_buffer[2]["E"][npc])
	for npc in collection:
		if not world_state_buffer[2]["E"].keys().has(npc):
			remove_from_the_collection(npc)


func extrapolate(_render_time, world_state_buffer):
	var extrapolation_factor = float(_render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.00

	for npc in world_state_buffer[1]["E"].keys():
		if not world_state_buffer[0]["E"].has(npc): # WE WANT TO BE SURE THAT BOTH WS0 AND WS1 HAVE ANY GIVEN KEY FOR EXTRAPOLATION'S SAKE
			continue
		if collection.has(npc):
			var modified_data := {}
			var position_delta = (world_state_buffer[1]["E"][npc]["pos"] - world_state_buffer[0]["E"][npc]["pos"])
			modified_data["pos"] = world_state_buffer[1]["E"][npc]["pos"] + (position_delta * extrapolation_factor)
			var current_rot = (world_state_buffer[1]["E"][npc]["rot"]).get_rotation_quat()
			var old_rot = (world_state_buffer[0]["E"][npc]["rot"]).get_rotation_quat()
			var rotation_delta = (current_rot - old_rot)
			modified_data["rot"] = Basis(current_rot + (rotation_delta * extrapolation_factor))
			update_inside_the_collection(npc, modified_data)
