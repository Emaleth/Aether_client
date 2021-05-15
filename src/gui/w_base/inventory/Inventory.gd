extends PanelContainer

onready var slot_grid = $MarginContainer/grid
onready var slot_path = preload("res://src/gui/w_base/slot/Slot.tscn")


func conf(actor):
	if slot_grid.get_child_count() < actor.inventory.size():
		for old_slot in slot_grid.get_children():
			slot_grid.remove_child(old_slot)
			old_slot.queue_free()
		for i in actor.inventory:
			var new_slot = slot_path.instance()
			slot_grid.add_child(new_slot)
			new_slot.conf(actor, i, "inventory")
	else:
		for i in actor.inventory:
			var new_slot = slot_grid.get_child(i)
			new_slot.conf(actor, i, "inventory")

func can_drop_data(position: Vector2, data) -> bool:
	return false
		
