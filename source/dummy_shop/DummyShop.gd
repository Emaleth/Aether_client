extends Spatial

var goods := []

func update(new_position, _goods):
	add_to_group("shop")
	transform.origin = new_position
	goods = _goods

