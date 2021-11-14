extends "res://source/ui/subcomponents/window/Window.gd"

onready var slot = preload("res://source/ui/subcomponents/slot/Slot.tscn")
onready var slot_grid = $VBoxContainer/ContentPanel/CenterContainer/GridContainer

func _ready() -> void:
	yield(get_tree().create_timer(1),"timeout")
	configure(GlobalVariables.pouch_data)

func configure(_data : Array):
	for i in slot_grid.get_children():
		i.queue_free()
	for i in _data:
		var new_slot = slot.instance()
		slot_grid.add_child(new_slot)
		new_slot.configure(i, "pouch")



