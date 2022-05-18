extends Node


remote func receive_data_tables(_data : Dictionary):
	if get_tree().get_rpc_sender_id() == 1:
		Variables.item_index = _data["item_index"]
		Variables.npc_index = _data["npc_index"]
		Variables.ability_index = _data["ability_index"]
	
