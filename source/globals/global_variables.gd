extends Node

# PLAYER CONTAINERS
var equipment_data := {} #ok
var inventory_data := [] #ok
var ability_data := [] #ok
var action_bar_data := [] #ok
var recipe_data := [] #ok
var attributes_data := {}
var currency_data := {} #ok
var resources_data := {} #ok

# GENERAL DATA
var camera_rig = null
var player_actor = null
var user_interface = null
var world = null
var chatting := false

# CLIENT SETTINGS
var settings := {}


static func get_item_data(_item : String) -> Array:
	var index_data := {}
	var type_data := {}
	index_data = LocalDataTables.item_index[_item]
	match index_data["type"]:
		"weapon":
			type_data = LocalDataTables.weapon_table[_item]
		"armor":
			type_data = LocalDataTables.armor_table[_item]
		"material":
			type_data = LocalDataTables.material_table[_item]
		"craft_recipe":
			type_data = LocalDataTables.craft_recipe_table[_item]
		"ability_scroll":
			type_data = LocalDataTables.ability_scroll_table[_item]
	return [index_data, type_data]


static func get_npc_data(_npc : String) -> Array:
	var index_data := {}
	var type_data := {}
	index_data = LocalDataTables.npc_index[_npc]
	match index_data["type"]:
		"mob":
			type_data = LocalDataTables.mob_table[_npc]
		"shop":
			type_data = LocalDataTables.shop_table[_npc]
	return [index_data, type_data]


static func get_ability_data(_ability : String) -> Array:
	var index_data := {}
	var type_data := {}
	index_data = LocalDataTables.ability_index[_ability]
	match index_data["type"]:
		"projectile":
			type_data = LocalDataTables.projectile_table[_ability]
		"area":
			type_data = LocalDataTables.area_table[_ability]
		"raycast":
			type_data = LocalDataTables.raycast_table[_ability]
	return [index_data, type_data]
