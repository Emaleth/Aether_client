extends PanelContainer


export var armor_slot : NodePath
export var weapon_slot : NodePath
#export var secondary_weapon : NodePath


onready var slots = {
	"armor" : get_node(armor_slot),
	"weapon" : get_node(weapon_slot),
#	"secondary_weapon" : get_node(secondary_weapon),
}

func configure(_data : Dictionary):
	for i in _data.keys():
		var new_slot = slots[i]
		new_slot.configure(_data[i], i)

	
func _ready() -> void:
	configure(GlobalVariables.equipment_data)
	GlobalVariables.player_actor.get_node("EqPanelPrewievRemoteTransform").remote_path = $VBoxContainer/HBoxContainer2/PanelContainer/ViewportContainer/Viewport/Camera.get_path()

