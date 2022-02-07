extends Spatial


var data : Dictionary

func _ready() -> void:
	add_to_group("res")
	
	
func update(new_position, _data):
	transform.origin = new_position
	data = _data
