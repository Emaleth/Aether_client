extends PanelContainer

onready var slot = preload("res://source/ui/subcomponents/slots/inventory_slot/InventorySlot.tscn")
onready var slot_grid = $VBoxContainer/GridContainer
onready var gold_label = $VBoxContainer/Label

func configure(_data : Array):
	var index = 0
	for i in slot_grid.get_children():
		i.hide()
		i.queue_free()
	for i in _data:
		var new_slot = slot.instance()
		slot_grid.add_child(new_slot)
		new_slot.configure(i, index)
		index += 1
		

func configure_g(_data : Dictionary):
	if _data.size() > 0:
		gold_label.text = str(_data["gold"])
	
	
func _ready() -> void:
	configure(GlobalVariables.inventory_data)
	configure_g(GlobalVariables.currency_data)

