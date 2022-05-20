extends Node

var item_index := {}
var npc_index := {}
var ability_index := {}


remote func receive_data_tables(_data : Dictionary):
	if get_tree().get_rpc_sender_id() == 1:
		Variables.item_index = _data["item_index"]
		Variables.npc_index = _data["npc_index"]
		Variables.ability_index = _data["ability_index"]
	

static func get_item_data(_item : String) -> Dictionary:
	var data : Dictionary = Variables.item_index[_item]
	return data


static func get_npc_data(_npc : String) -> Dictionary:
	var data : Dictionary = Variables.npc_index[_npc]
	return data


static func get_ability_data(_ability : String) -> Dictionary:
	var data : Dictionary = Variables.ability_index[_ability]
	return data
