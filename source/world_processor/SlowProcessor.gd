extends Node

var slow_add_to_the_tree_index_register := [4]
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
	update_in_the_tree()
	slow_add_to_the_tree()


func configure(_player_container, _npc_container, _ability_container, _resource_node_container):
	buffer_index_table[1]["container"] = _player_container
	buffer_index_table[2]["container"] = _npc_container
	buffer_index_table[3]["container"] = _ability_container
	buffer_index_table[4]["container"] = _resource_node_container


func update_in_the_tree():
	for index in buffer_index_table:
		for npc in buffer_index_table[index]["container"].get_children():
			if buffer_index_table[index]["collection"].has(str(npc.name)):
				npc.update_data(buffer_index_table[index]["collection"][str(npc.name)])
		if index == 1:
			if buffer_index_table[index]["collection"].has(str(get_tree().get_network_unique_id())):
				GlobalVariables.resources_data = buffer_index_table[index]["collection"][str(get_tree().get_network_unique_id())][0]


func slow_add_to_the_tree():
	for index in buffer_index_table:
		if index in slow_add_to_the_tree_index_register:
			# ADD
			for npc in buffer_index_table[index]["collection"].keys():
				if not buffer_index_table[index]["container"].has_node(str(npc)):
					var new_npc = buffer_index_table[index]["scene"].instance()
					new_npc.name = str(npc)
					buffer_index_table[index]["container"].call_deferred("add_child", new_npc, true)
			# REMOVE
			for npc in buffer_index_table[index]["collection"]:
				if not buffer_index_table[index]["collection"].keys().has(npc):
					buffer_index_table[index]["collection"].erase(npc)
			
			
func update_world_state(world_state):
	for index in buffer_index_table:
		buffer_index_table[index]["collection"] = world_state[index]
		
