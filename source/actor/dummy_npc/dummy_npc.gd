extends KinematicBody

enum mstates {ALIVE, DEAD_LOOTABLE, DEAD_EMPTY}

var master_state : int

onready var name_plate = $NamePlate


func _ready() -> void:
	name = str(get_index())
	add_to_group("Actor")
	
	
func update_data(_data):
	name_plate.set_name_label(str(name))
	name_plate.update_health_bar(_data[0], 100)
	change_master_state(_data[1])


func change_master_state(_master_state):
	match _master_state:
		mstates.ALIVE:
			show()
		mstates.DEAD_EMPTY:
			hide()
	master_state = _master_state
