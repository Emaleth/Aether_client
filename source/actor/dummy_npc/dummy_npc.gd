extends KinematicBody

onready var name_plate = $NamePlate


func _ready() -> void:
	name = str(get_index())
	add_to_group("Actor")
	
	
func update_data(_data):
	name_plate.set_name_label(str(name))
	name_plate.update_health_bar(_data[0], 100)
	
