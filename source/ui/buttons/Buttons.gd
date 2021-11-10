extends "res://source/ui/subcomponents/window/Window.gd"


onready var inventory_button := $VBoxContainer/ContentPanel/GridContainer/Inventory
onready var equipment_button := $VBoxContainer/ContentPanel/GridContainer/Equipment

signal toggled_inventory_window
signal toggled_equipment_window


func _on_Inventory_pressed() -> void:
	emit_signal("toggled_inventory_window")
		
func _on_Equipment_pressed() -> void:
	emit_signal("toggled_equipment_window")


