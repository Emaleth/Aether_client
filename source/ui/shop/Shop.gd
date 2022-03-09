extends PanelContainer

onready var slot = preload("res://source/ui/subcomponents/slots/shop_slot/ShoppingSlot.tscn")

onready var slot_grid = $GridContainer


func configure(_data : Array, _shop_id : int):
	var index = 0
	for i in slot_grid.get_children():
		i.hide()
		i.queue_free()
	for i in _data:
		var new_slot = slot.instance()
		slot_grid.add_child(new_slot)
		new_slot.configure(i, index, _shop_id)
		index += 1
#
#

