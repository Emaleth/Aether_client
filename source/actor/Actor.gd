extends KinematicBody


var data : Dictionary = {}

onready var name_plate := $NamePlate


func _ready() -> void:
	configure()
	
	
func configure():
	add_to_group("Actor")
	data = Variables.get_npc_data(data.type)
	name_plate.set_name_label(str(data[0]["name"]))
	

func update(_data):
	for i in _data:
		data[i] = _data[i]
	name_plate.update_health_bar(_data[0], data[1]["health"])


func move():
	pass
