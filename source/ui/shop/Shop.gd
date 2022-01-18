extends PanelContainer

onready var slot = preload("res://source/ui/subcomponents/shop_slot/ShopSlot.tscn")

onready var buy_slot_grid = $CenterContainer/HBoxContainer/BuySection/GridContainer
onready var sell_slot_grid = $CenterContainer/HBoxContainer/SellSection/GridContainer


func configure_buy(_data : Array):
	var index = 0
	for i in buy_slot_grid.get_children():
		i.hide()
		i.queue_free()
	for i in _data:
		var new_slot = slot.instance()
		buy_slot_grid.add_child(new_slot)
		var x = {"archetype" : i, "amount" : 1}
		new_slot.configure(x, "shop", index)
		index += 1


func configure_sell(_data : Array):
	var index = 0
	for i in sell_slot_grid.get_children():
		i.hide()
		i.queue_free()
	for i in _data:
		var new_slot = slot.instance()
		sell_slot_grid.add_child(new_slot)
#		print(index)
		new_slot.configure(i, "inventory", index)
#		print(i, "inventory", index)
		index += 1


func _ready() -> void:
	configure_sell(GlobalVariables.inventory_data)

