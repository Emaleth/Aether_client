extends PanelContainer


onready var slot_grid : GridContainer = $GridContainer
onready var slot_scene = preload("res://source/UI/layers/dashboard/panels/item_slot/ItemSlot.tscn")


func configure(_data : Dictionary):
	for i in _data.size():
		var slot_slot = slot_grid.get_node(_data.keys()[i])
		var new_slot = slot_scene.instance()
		new_slot.configure(_data.keys()[i], _data.values()[i], "equipment")
		slot_slot.add_child(new_slot)

