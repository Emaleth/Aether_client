extends KinematicBody


var remote_data : Dictionary = {
	"transform" : "",
	"id" : "",
	"type" : "",
	"name" : ""
}

var local_data : Dictionary
onready var name_plate := $NamePlate
onready var collision_shape := $CollisionShapeBody


func _ready() -> void:
#	name = str(get_index())
	add_to_group("Actor")
	data = GlobalVariables.get_npc_data(data.type)
	name_plate.set_name_label(str(data[0]["name"]))
	
	
func update_data(_data):
	name_plate.update_health_bar(_data[0], data[1]["health"])


func configure(_data : Dictionary):
	for i in _data:
		data[i] = _data[i]
