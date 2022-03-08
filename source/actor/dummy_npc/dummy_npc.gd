extends KinematicBody

enum mstates {ALIVE, DEAD_LOOTABLE, DEAD_EMPTY}

var master_state : int
var type := "training_dummy"
var data := []
#var loot := []
onready var loot_node := $Loot
onready var name_plate := $NamePlate
onready var collision_shape := $CollisionShapeBody
onready var mesh := $MeshInstance


func _ready() -> void:
	name = str(get_index())
	add_to_group("Actor")
	loot_node.add_to_group("loot")
	data = GlobalVariables.get_npc_data(type)
	name_plate.set_name_label(str(data[0]["name"]))
	
	
func update_data(_data):
	name_plate.update_health_bar(_data[0], data[1]["health"])
	change_master_state(_data[1])
	loot_node.loot = _data[2]


func change_master_state(_master_state):
	match _master_state:
		mstates.ALIVE:
			collision_shape.disabled = false
			name_plate.show()
			mesh.show()
			loot_node.hide()
		mstates.DEAD_LOOTABLE:
			collision_shape.disabled = true
			name_plate.hide()
			mesh.hide()
			loot_node.show()
		mstates.DEAD_EMPTY:
			collision_shape.disabled = true
			name_plate.hide()
			mesh.hide()
			loot_node.hide()

	master_state = _master_state
