extends Node


static func interpolate_basis(from : Basis, to : Basis, weight : float) -> Basis:
	var basis : Basis
	var from_quat : Quat = from.get_rotation_quat()
	var to_quat : Quat = to.get_rotation_quat()
	basis = Basis(from_quat.slerp(to_quat, weight))
	return basis


static func extrapolate_basis(current : Basis, old : Basis, weight : float) -> Basis:
	var basis : Basis
	var current_quat = current.get_rotation_quat()
	var old_quat = old.get_rotation_quat()
	var delta_quat = (current_quat - old_quat)
	basis = Basis(current_quat + (delta_quat * weight))
	return basis


static func get_item_data(_item : String) -> Dictionary:
	var data : Dictionary = Variables.item_index[_item]
	return data


static func get_npc_data(_npc : String) -> Dictionary:
	var data : Dictionary = Variables.npc_index[_npc]
	return data


static func get_ability_data(_ability : String) -> Dictionary:
	var data : Dictionary = Variables.ability_index[_ability]
	return data
