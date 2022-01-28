extends Area

var ability : String

func update(new_position, new_rotation):
	global_transform.origin = new_position
	global_transform.basis = new_rotation
		
