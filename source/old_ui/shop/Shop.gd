extends PanelContainer

onready var slot = preload("res://source/ui/subcomponents/slots/shop_slot/ShoppingSlot.tscn")
onready var buy_grid := $HBoxContainer/BuyGrid
onready var sell_grid := $HBoxContainer/SellGrid
var shop_id : int

func configure_buy_grid(_data : Array):
	var index = 0
	for i in buy_grid.get_children():
		i.hide()
		i.queue_free()
	for i in _data:
		var new_slot = slot.instance()
		buy_grid.add_child(new_slot)
		new_slot.configure(i, index, true)
		index += 1


func configure_sell_grid(_data : Array):
	var index = 0
	for i in sell_grid.get_children():
		i.hide()
		i.queue_free()
	for i in _data:
		if i == null:
			continue
		var new_slot = slot.instance()
		sell_grid.add_child(new_slot)
		new_slot.configure(i, index, false)
		index += 1
#
	
func _ready() -> void:
	configure_sell_grid(GlobalVariables.inventory_data)


