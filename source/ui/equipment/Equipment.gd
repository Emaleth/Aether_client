extends PanelContainer


export var chest_slot : NodePath
export var right_hand_slot : NodePath
export var left_hand_slot : NodePath

onready var slots = {
	"chest" : get_node(chest_slot),
	"primary_weapon" : get_node(right_hand_slot),
	"secondary_weapon" : get_node(left_hand_slot),
}

func configure(_data : Dictionary):
	for i in _data.keys():
		var new_slot = slots[i]
		new_slot.configure(_data[i], i)

	
func _ready() -> void:
	configure(GlobalVariables.equipment_data)
	GlobalVariables.player_actor.get_node("EqPanelPrewievRemoteTransform").remote_path = $VBoxContainer/HBoxContainer2/PanelContainer/ViewportContainer/Viewport/Camera.get_path()

#func _unhandled_input(_event: InputEvent) -> void:
#	if Input.is_action_just_pressed("primary_action"):
#		Server.send_weapon_use_request("primary")
#	elif Input.is_action_just_pressed("secondary_action"):
#		Server.send_weapon_use_request("secondary")
