extends PanelContainer

var slot = preload("res://gui/Slot.tscn")
onready var grid = $GridContainer

	
func conf(actor, quantity_panel):
	if grid.get_child_count() < actor.quickbar.size():
		for old_slot in grid.get_children():
			grid.remove_child(old_slot)
			old_slot.queue_free()
		for i in actor.quickbar:
			var new_slot = slot.instance()
			grid.add_child(new_slot)
			new_slot.conf(actor, i, "quickbar", quantity_panel)
	else:
		for i in actor.quickbar:
			var new_slot = grid.get_child(i)
			new_slot.conf(actor, i, "quickbar", quantity_panel)
			
