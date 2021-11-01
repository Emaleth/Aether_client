extends PanelContainer


onready var slot = preload("res://interface/subcomponents/slot/Slot.tscn")
onready var button_list = null


func configure(_data : Dictionary):
	for i in _data.keys():
		var new_slot = slot.instance()
		$GridContainer.add_child(new_slot)
		new_slot.configure(_data[i], button_list)
