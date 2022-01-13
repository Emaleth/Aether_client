extends PanelContainer

onready var slot = preload("res://source/ui/subcomponents/slot/Slot.tscn")

export var chest_slot : NodePath
export var right_hand_slot : NodePath
export var left_hand_slot : NodePath
export var inventory_slot : NodePath
export var pouch_slot : NodePath
export var spellbook_slot : NodePath

onready var slots = {
	"chest" : get_node(chest_slot),
	"right_hand" : get_node(right_hand_slot),
	"left_hand" : get_node(left_hand_slot),
	"inventory" : get_node(inventory_slot),
	"pouch" : get_node(pouch_slot),
	"spellbook" : get_node(spellbook_slot),
}

func configure(_data : Dictionary):
	var index = 0
	for i in _data.keys():
		var new_slot = slots[i]
		new_slot.configure(_data[i], "equipment", index, null, new_slot.ITEM)
		index += 1
	
	
func _ready() -> void:
	configure(GlobalVariables.equipment_data)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("primary_action"):
		Server.send_weapon_use_request("primary")
	elif Input.is_action_just_pressed("secondary_action"):
		Server.send_weapon_use_request("secondary")
