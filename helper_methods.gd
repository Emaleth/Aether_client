extends Node


func interpolate_basis(from : Basis, to : Basis, weight : float) -> Basis:
	var basis : Basis
	
	var from_quat : Quat = from.get_rotation_quat()
	var to_quat : Quat = to.get_rotation_quat()
	basis = Basis(from_quat.slerp(to_quat, weight))
	
	return basis


func extrapolate_basis(current : Basis, old : Basis, weight : float) -> Basis:
	var basis : Basis
	
	var current_quat = current.get_rotation_quat()
	var old_quat = old.get_rotation_quat()
	var delta_quat = (current_quat - old_quat)
	basis = Basis(current_quat + (delta_quat * weight))

	return basis
