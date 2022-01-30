extends PanelContainer

onready var slot = preload("res://source/ui/subcomponents/slot/Slot.tscn")

onready var slot_grid = $GridContainer


func configure_buy(_data : Array):
	var index = 0
	for i in slot_grid.get_children():
		i.hide()
		i.queue_free()
	for i in _data:
		var new_slot = slot.instance()
		slot_grid.add_child(new_slot)
		var x = {"archetype" : i, "amount" : 1}
		new_slot.configure(x, "shop", index, null, true)
		index += 1



