extends StaticBody

var item := ""
var amount := 0


func update(new_position, _item):
	transform.origin = new_position
	item = _item.keys()[0]
	amount = _item.values()[0]
