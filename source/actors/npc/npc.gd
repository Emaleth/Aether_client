extends KinematicBody

enum mstates {ALIVE, DEAD_LOOTABLE, DEAD_EMPTY}

var master_state : int
var type := "training_dummy"
var data := []

onready var name_plate := $NamePlate
onready var collision_shape := $CollisionShapeBody
onready var mesh := $actor/Icosphere


func _ready() -> void:
	name = str(get_index())
	add_to_group("Actor")
	data = GlobalVariables.get_npc_data(type)
	name_plate.set_name_label(str(data[0]["name"]))
	
	
func update_data(_data):
	name_plate.update_health_bar(_data[0], data[1]["health"])
	change_master_state(_data[1])


func change_master_state(_master_state):
	match _master_state:
		mstates.ALIVE:
			collision_shape.disabled = false
			if is_in_group("loot"):
				remove_from_group("loot")
			name_plate.show()
			var m = mesh.get("material/0").duplicate()
			m.set("albedo_color", Color.red)
			mesh.set("material/0", m)
			mesh.show()
		mstates.DEAD_LOOTABLE:
			add_to_group("loot")
			collision_shape.disabled = false
			name_plate.hide()
			var m = mesh.get("material/0").duplicate()
			m.set("albedo_color", Color.green)
			mesh.set("material/0", m)
			mesh.show()
		mstates.DEAD_EMPTY:
			if is_in_group("loot"):
				remove_from_group("loot")
			collision_shape.disabled = true
			name_plate.hide()
			mesh.hide()

	master_state = _master_state
