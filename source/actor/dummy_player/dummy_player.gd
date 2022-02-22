extends KinematicBody

onready var name_plate = $NamePlate


func _ready() -> void:
	add_to_group("Actor")
	
