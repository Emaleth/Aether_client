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
	update_in_the_tree()


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

			
func update_world_state(world_state):
	for index in buffer_index_table:
		buffer_index_table[index]["collection"] = world_state[index]
		
