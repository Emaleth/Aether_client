extends "res://source/ui/subcomponents/window/Window.gd"

onready var slot = preload("res://source/ui/subcomponents/slot/Slot.tscn")
onready var slot_grid = $CenterContainer/GridContainer

var max_rows = 5 


func configure(_data : Array):
	for i in slot_grid.get_children():
		i.hide()
		i.queue_free()
	for i in _data:
		var new_slot = slot.instance()
		slot_grid.add_child(new_slot)
		new_slot.configure(i, "inventory")
#		new_slot.connect("swap", self, "swap_slots")
	calculate_scroll_container_size(ceil(_data.size() / float(slot_grid.columns)), slot_grid.get_constant("vseparation"), 40)
	resize()


func _ready() -> void:
	configure(GlobalVariables.inventory_data)


func swap_slots(slot_a, slot_b):
	slot_a["slot"].configure(slot_b["item"])
	slot_b["slot"].configure(slot_a["item"])


func calculate_scroll_container_size(rows, v_sep, slot_y):
	var new_size_y = min(
			rows * slot_y + (rows  -1) * v_sep,
			max_rows * slot_y + (3 - 1) * v_sep
	)
	slot_grid.rect_min_size.y = new_size_y
	slot_grid.rect_size.y = new_size_y

