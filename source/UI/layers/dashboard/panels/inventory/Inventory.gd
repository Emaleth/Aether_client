extends PanelContainer


onready var slot_list = $ScrollContainer/VBoxContainer
onready var slot_scene = preload("res://source/UI/layers/dashboard/panels/item_slot/ItemSlot.tscn")


func configure(_data : Dictionary):
	for i in _data.size():
		var new_slot = slot_scene.instance()
		new_slot.configure(_data.keys()[i], _data.values()[i], "inventory")
		slot_list.add_child(new_slot)
