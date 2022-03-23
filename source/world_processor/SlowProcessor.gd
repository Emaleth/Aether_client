extends Node


onready var projectile := preload("res://source/projectile_ability/ProjectileAbility.tscn")

var buffer_index_table := {
	1 : { # PLAYERS
		"collection" : {},
		"container" : null,
	},
	2 : { # NPC
		"collection" : {},
		"container" : null,
	},
	3 : { # RESOURCE NODES
		"collection" : {},
		"container" : null,
	}
}

var ability_container = null # WORLD STATE INDEX 4


func _physics_process(_delta: float) -> void:
	update_in_the_tree()


func configure(_player_container, _npc_container, _resource_node_container, _ability_container):
	buffer_index_table[1]["container"] = _player_container
	buffer_index_table[2]["container"] = _npc_container
	buffer_index_table[3]["container"] = _resource_node_container
	ability_container = _ability_container


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
	process_abilities(world_state[4])


func process_abilities(_data):
	for i in _data:
		var new_ability = projectile.instance()
		new_ability.configure(i[1], GlobalVariables.get_ability_data(i[0]))
		ability_container.add_child(new_ability, true)
	
	
