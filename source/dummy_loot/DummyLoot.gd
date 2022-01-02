extends StaticBody

var item := ""
var amount := 0


func update(new_position, _item, _amount):
	transform.origin = new_position
	item = _item
	amount = _amount
