extends Spatial


var type : String
var state : bool

func _ready() -> void:
	name = str(get_index())
	add_to_group("resource")
	
	
func update_data(_data):
	global_transform = _data[0]
	type = _data[1]
	state = _data[2]
	if state:
		show()
	else:
		hide()
