extends KinematicBody

onready var name_plate = $NamePlate


func _ready() -> void:
	add_to_group("Actor")
	
func update(new_position, new_rotation, _res):
	transform.origin = new_position
	transform.basis = new_rotation
	name_plate.update_health_bar(_res["health"]["current"], _res["health"]["max"])
