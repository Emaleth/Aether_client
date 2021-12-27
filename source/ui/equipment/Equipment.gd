extends PanelContainer

onready var slot = preload("res://source/ui/subcomponents/slot/Slot.tscn")
onready var slot_grid = $HBoxContainer/CenterContainer/GridContainer


func configure(_data : Dictionary):
	for i in slot_grid.get_children():
		i.hide()
		i.queue_free()
	for i in _data.keys():
		var new_slot = slot.instance()
		slot_grid.add_child(new_slot)
		new_slot.configure(_data[i], "equipment")
	
	
func _ready() -> void:
	configure(GlobalVariables.equipment_data)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("primary_action"):
		Server.send_weapon_use_request("primary")
	elif Input.is_action_just_pressed("secondary_action"):
		Server.send_weapon_use_request("secondary")
