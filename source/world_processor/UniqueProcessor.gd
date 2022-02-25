extends Node

var buffer_index_table := {
	0 : { # SHOP
		"collection" : {},
		"container" : null,
		"scene" : preload("res://source/dummy_shop/DummyShop.tscn")
	},
	1 : { # CRAFTING STATION
		"collection" : {},
		"container" : null,
		"scene" : preload("res://source/dummy_crafting_station/DummyCraftingStation.tscn")
	}
}


func configure(_shop_container, _crafting_station_container):
	buffer_index_table[0]["container"] = _shop_container
	buffer_index_table[1]["container"] = _crafting_station_container
	configure_world_state(GlobalVariables.unique_world_state)
	add_to_the_tree()


func add_to_the_tree():
	for index in buffer_index_table:
		for npc in buffer_index_table[index]["collection"].keys():
			if not buffer_index_table[index]["container"].has_node(str(npc)):
				var new_npc = buffer_index_table[index]["scene"].instance()
				new_npc.name = str(npc)
				buffer_index_table[index]["container"].call_deferred("add_child", new_npc, true)
				new_npc.global_transform = buffer_index_table[index]["collection"][str(npc)][0]

			
func configure_world_state(world_state):
	if world_state.size() == 0:
		return
	for index in buffer_index_table:
		buffer_index_table[index]["collection"] = world_state[index]
		
