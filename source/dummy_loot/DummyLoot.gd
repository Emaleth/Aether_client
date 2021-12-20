extends MeshInstance


func update(new_position):
	if global_transform.origin != new_position:
		global_transform.origin = new_position
#	print(new_position)
