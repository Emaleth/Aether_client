extends PanelContainer


onready var slot_list = $ScrollContainer/VBoxContainer


func configure(_data : Dictionary):
	for i in _data.size():
		slot_list.configure(_data.keys()[i], _data.values()[i], "inventory")
		
