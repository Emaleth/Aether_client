extends StaticBody


func update(new_position):
	if transform.origin != new_position: print("oof")
	transform.origin = new_position
#	print(new_position)
