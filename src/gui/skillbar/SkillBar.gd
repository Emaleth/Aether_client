extends PanelContainer

var slot = preload("res://src/gui/w_base/slot/Slot.tscn")
onready var grid = $MarginContainer/GridContainer

	
func conf(actor):
	if grid.get_child_count() < actor.skillbar.size():
		for old_slot in grid.get_children():
			grid.remove_child(old_slot)
			old_slot.queue_free()
		for i in actor.skillbar:
			var new_slot = slot.instance()
			grid.add_child(new_slot)
			new_slot.conf(actor, i, "skillbar")
	else:
		for i in actor.skillbar:
			var new_slot = grid.get_child(i)
			new_slot.conf(actor, i, "skillbar")
			
