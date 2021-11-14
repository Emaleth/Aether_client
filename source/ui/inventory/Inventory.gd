extends "res://source/ui/subcomponents/window/Window.gd"

onready var slot = preload("res://source/ui/subcomponents/slot/Slot.tscn")
onready var slot_grid = $VBoxContainer/ContentPanel/CenterContainer/GridContainer



func configure(_data : Array):
	for i in slot_grid.get_children():
		i.queue_free()
	for i in _data:
		var new_slot = slot.instance()
		slot_grid.add_child(new_slot)
		new_slot.configure(i, "inventory")
		new_slot.connect("swap", self, "swap_slots")


func _on_Inventory_visibility_changed() -> void:
	if visible:
		configure(GlobalVariables.inventory_data)

func swap_slots(slot_a, slot_b):
	slot_a["slot"].configure(slot_b["item"])
	slot_b["slot"].configure(slot_a["item"])
