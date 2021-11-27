extends Area

var type : String

func update(new_position, new_rotation):
	transform.origin = new_position
	transform.basis = new_rotation
		
