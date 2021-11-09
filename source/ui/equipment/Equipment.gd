extends "res://source/ui/subcomponents/window/Window.gd"

onready var slot = preload("res://source/ui/subcomponents/slot/Slot.tscn")
onready var slot_grid = $VBoxContainer/ContentPanel/GridContainer


func _ready() -> void:
	window_title_label.text = "Equipment"
	configure(GlobalVariables.equipment_data)
	
func configure(_data : Dictionary):
	for i in _data.keys():
		var new_slot = slot.instance()
		slot_grid.add_child(new_slot)
		new_slot.configure(_data[i])
