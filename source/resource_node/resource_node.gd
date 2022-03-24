extends StaticBody


var type : String
var state : bool

func _ready() -> void:
	name = str(get_index())
	add_to_group("resource")
	
	
func update_data(_data):
	state = _data[0]
	if state:
		show()
	else:
		hide()
