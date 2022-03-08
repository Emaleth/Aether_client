extends KinematicBody

onready var name_plate := $NamePlate
onready var loot := $Loot


func _ready() -> void:
	add_to_group("Actor")
	
	
func update_data(_data):
	print(_data)
