extends Node

const interpolation_offset = 100 # milliseconds
# FAST
var world_state_buffer = []
var last_world_state := 0.0
var render_time : float


var buffer_index_table := {
	1 : { # PLAYERS
		"collection" : {},
		"container" : null,
		"scene" : preload("res://source/actor/dummy_player/dummy_player.tscn")
	},
	2 : { # NPC
		"collection" : {},
		"container" : null,
		"scene" : preload("res://source/actor/dummy_npc/dummy_npc.tscn")
	},
	3 : { # ABILITY
		"collection" : {},
		"container" : null,
		"scene" : preload("res://source/projectile/dummyBullet.tscn") 
	},
}


func _physics_process(_delta: float) -> void:
	interpolate_or_extrapolate()
#	add_to_the_tree()
	update_in_the_tree()
#	remove_from_the_tree()


func update_world_state(_world_state):
	if float(_world_state[0]) > last_world_state:
		last_world_state = _world_state[0]
		world_state_buffer.append(_world_state)
		

func interpolate_or_extrapolate():
	render_time = Server.client_clock - interpolation_offset
	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > float(world_state_buffer[2][0]):
			world_state_buffer.remove(0)
		if world_state_buffer.size() > 2:
			interpolate()
		elif render_time > float(world_state_buffer[1][0]):
			extrapolate()


func configure(_player_container, _npc_container, _ability_container):
	buffer_index_table[1]["container"] = _player_container
	buffer_index_table[2]["container"] = _npc_container
	buffer_index_table[3]["container"] = _ability_container

	
#func add_to_the_tree():
#	for index in buffer_index_table:
#		for npc in buffer_index_table[index]["collection"].keys():
#			if npc == str(get_tree().get_network_unique_id()):
#				if GlobalVariables.player_actor == null:
#					get_parent().get_node("CharacterProcessor").spawn_character()
#			else:
#				if not buffer_index_table[index]["container"].has_node(str(npc)):
#					var new_npc = buffer_index_table[index]["scene"].instance()
#					new_npc.name = str(npc)
#					buffer_index_table[index]["container"].call_deferred("add_child", new_npc, true)



func update_in_the_tree():
	for index in buffer_index_table:
		for npc in buffer_index_table[index]["container"].get_children():
			if buffer_index_table[index]["collection"].has(str(npc.name)):
				npc.global_transform = buffer_index_table[index]["collection"][str(npc.name)]


#func remove_from_the_tree():
#	for index in buffer_index_table:
#		for npc in buffer_index_table[index]["container"].get_children():
#			if not buffer_index_table[index]["collection"].has(str(npc.name)):
#				npc.call_deferred("queue_free")


func add_to_the_collection(_index, _id, _data):
	buffer_index_table[_index]["collection"][_id] = _data


func update_inside_the_collection(_index, _id, _data):
	buffer_index_table[_index]["collection"][_id] = _data


func remove_from_the_collection(_index, _id):
	buffer_index_table[_index]["collection"].erase(_id)


func interpolate():
	var interpolation_factor = float(render_time - world_state_buffer[1][0]) / float(world_state_buffer[2][0] - world_state_buffer[1][0])
	for index in buffer_index_table:
		for npc in world_state_buffer[2][index].keys():
			if not world_state_buffer[1][index].has(npc): # WE WANT TO BE SURE THAT BOTH WS1 AND WS2 HAVE ANY GIVEN KEY FOR INTERPOLATION'S SAKE
				continue
			if buffer_index_table[index]["collection"].has(npc):
				var modified_data = Transform.IDENTITY
				modified_data.origin = lerp(world_state_buffer[1][index][npc].origin, world_state_buffer[2][index][npc].origin, interpolation_factor)
				var current_rot = (world_state_buffer[1][index][npc].basis).get_rotation_quat()
				var target_rot = (world_state_buffer[2][index][npc].basis).get_rotation_quat()
				modified_data.basis = Basis(current_rot.slerp(target_rot, interpolation_factor))
				update_inside_the_collection(index, npc, modified_data)
			else:
				add_to_the_collection(index, npc, world_state_buffer[2][index][npc])
		for npc in buffer_index_table[index]["collection"]:
			if not world_state_buffer[2][index].keys().has(npc):
				remove_from_the_collection(index, npc)


func extrapolate():
	var extrapolation_factor = float(render_time - world_state_buffer[0][0]) / float(world_state_buffer[1][0] - world_state_buffer[0][0]) - 1.00
	for index in buffer_index_table:
		for npc in world_state_buffer[1][index].keys():
			if not world_state_buffer[0][index].has(npc): # WE WANT TO BE SURE THAT BOTH WS0 AND WS1 HAVE ANY GIVEN KEY FOR EXTRAPOLATION'S SAKE
				continue
			if buffer_index_table[index]["collection"].has(npc):
				var position_delta = (world_state_buffer[1][index][npc].origin - world_state_buffer[0][index][npc].origin)
				var modified_data = Transform.IDENTITY
				modified_data.origin = world_state_buffer[1][index][npc].origin + (position_delta * extrapolation_factor)
				var current_rot = (world_state_buffer[1][index][npc].basis).get_rotation_quat()
				var old_rot = (world_state_buffer[0][index][npc].basis).get_rotation_quat()
				var rotation_delta = (current_rot - old_rot)
				modified_data.basis = Basis(current_rot + (rotation_delta * extrapolation_factor))
				update_inside_the_collection(index, npc, modified_data)
