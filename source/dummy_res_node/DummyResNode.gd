extends Spatial


var type : String

func _ready() -> void:
	add_to_group("res")
	
	
func update_data(_data):
	global_transform = _data[0]
	type = _data[1]
