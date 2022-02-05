extends Spatial


var type := ""
var charge := 0

func update(new_position, _type, _charge):
	add_to_group("res")
	transform.origin = new_position
	type = _type
	charge = _charge

