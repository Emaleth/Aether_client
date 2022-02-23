extends KinematicBody

onready var name_plate = $NamePlate


func _ready() -> void:
	add_to_group("Actor")
	
	
func update_data(_data):
	name_plate.set_name_label(str(name))
	name_plate.update_health_bar(_data[0]["h"]["c"], _data[0]["h"]["m"])
	name_plate.update_mana_bar(_data[0]["m"]["c"], _data[0]["m"]["m"])
