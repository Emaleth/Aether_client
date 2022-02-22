extends Node


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
	4 : { # RESOURCE NODES
		"collection" : {},
		"container" : null,
		"scene" : preload("res://source/dummy_res_node/DummyResNode.tscn") 
	}
}


func _physics_process(_delta: float) -> void:
	add_to_the_tree()
	update_in_the_tree()
	remove_from_the_tree()


func configure(_player_container, _npc_container, _ability_container, _resource_node_container):
	buffer_index_table[1]["container"] = _player_container
	buffer_index_table[2]["container"] = _npc_container
	buffer_index_table[3]["container"] = _ability_container
	buffer_index_table[4]["container"] = _resource_node_container

	
func add_to_the_tree():
	for index in buffer_index_table:
		for npc in buffer_index_table[index]["collection"].keys():
			if npc == str(get_tree().get_network_unique_id()):
				if GlobalVariables.player_actor == null:
					get_parent().get_node("CharacterProcessor").spawn_character()
			else:
				if not buffer_index_table[index]["container"].has_node(str(npc)):
					var new_npc = buffer_index_table[index]["scene"].instance()
					new_npc.name = str(npc)
					buffer_index_table[index]["container"].call_deferred("add_child", new_npc, true)



func update_in_the_tree():
	for index in buffer_index_table:
		for npc in buffer_index_table[index]["container"].get_children():
			if buffer_index_table[index]["collection"].has(str(npc.name)):
				pass
#				npc.update_data(buffer_index_table[index]["collection"][str(npc.name)])


func remove_from_the_tree():
	for index in buffer_index_table:
		for npc in buffer_index_table[index]["container"].get_children():
			if not buffer_index_table[index]["collection"].has(str(npc.name)):
				npc.call_deferred("queue_free")


func add_to_the_collection(_index, _id, _data):
	buffer_index_table[_index]["collection"][_id] = _data


func update_inside_the_collection(_index, _id, _data):
	buffer_index_table[_index]["collection"][_id] = _data


func remove_from_the_collection(_index, _id):
	buffer_index_table[_index]["collection"].erase(_id)


func update_world_state(world_state):
	for index in buffer_index_table:
		for npc in world_state[index].keys():
			if buffer_index_table[index]["collection"].has(npc):
				update_inside_the_collection(index, npc, world_state[index][npc])
			else:
				add_to_the_collection(index, npc, world_state[index][npc])
		for npc in buffer_index_table[index]["collection"]:
			if not world_state[index].keys().has(npc):
				remove_from_the_collection(index, npc)

