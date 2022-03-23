extends KinematicBody

onready var name_plate = $NamePlate
onready var weapon_pivot := $weapon_pivot

func _ready() -> void:
	add_to_group("Actor")
	
	
func update_data(_data):
	name_plate.set_name_label(str(name))
	name_plate.update_health_bar(_data[0]["h"]["c"], _data[0]["h"]["m"])
	name_plate.update_mana_bar(_data[0]["m"]["c"], _data[0]["m"]["m"])
	aim(_data[1])
	
	
func aim(target_data : Array):
	for i in target_data:
		weapon_pivot.global_transform = i
		weapon_pivot.get_node("MeshInstance").shoot()



	
