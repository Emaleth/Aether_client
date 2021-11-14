extends "res://source/ui/subcomponents/window/Window.gd"

onready var slot = preload("res://source/ui/subcomponents/slot/Slot.tscn")
onready var slot_grid = $VBoxContainer/ContentPanel/CenterContainer/GridContainer


func configure(_data : Dictionary):
	for i in slot_grid.get_children():
		i.queue_free()
	for i in _data.keys():
		var new_slot = slot.instance()
		slot_grid.add_child(new_slot)
		new_slot.configure(_data[i], "equipment")


func _on_Equipment_visibility_changed() -> void:
	if visible:
		configure(GlobalVariables.equipment_data)
