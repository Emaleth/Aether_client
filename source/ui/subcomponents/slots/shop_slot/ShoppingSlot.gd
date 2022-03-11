extends Button

var item = null
var index : int
var buy : bool
onready var tooltip = preload("res://source/ui/tooltips/inventory_tooltip/InventoryTooltip.tscn")
onready var interaction_menu = $InteractionMenu
onready var amount_label := $GridContainer/AmountLabel

func configure(_item, _index, _buy):
	item = _item
	index = _index
	buy = _buy
	set_dummy_tooltip_text()
	set_item_icon()
	set_amount_label()
	connect_interaction_menu_signals()
	
	
func set_dummy_tooltip_text() -> void:
	hint_tooltip = "text" if item else ""
	

func connect_interaction_menu_signals():
	if buy:
		interaction_menu.connect("buy", Server, "request_item_buy", [get_parent().get_parent().get_parent().shop_id, index])
	else:
		interaction_menu.connect("sell", Server, "request_item_sell", [get_parent().get_parent().get_parent().shop_id, index])

	
func _make_custom_tooltip(_for_text: String) -> Control:
	var new_tooltip = tooltip.instance()
	if buy:
		new_tooltip.conf(item)
	else:
		new_tooltip.conf(item["item"])
	return new_tooltip
				
		
func set_item_icon() -> void:
	if item:
		var item_icon_path : String
		if buy:
			item_icon_path = "res://assets/icons/item//%s.svg" % str(item)
		else:
			item_icon_path = "res://assets/icons/item//%s.svg" % str(item["item"])
		icon = load(item_icon_path) if ResourceLoader.exists(item_icon_path) else preload("res://assets/icons/no_icon.svg")
	else:
		icon = null


func set_amount_label() -> void:
	if item:
		if buy:
			amount_label.text = ""
		else:
			amount_label.text = "" if item["amount"] == 1 else str(item["amount"])
	else:
		amount_label.text = ""
		
		
func _on_InventorySlot_pressed() -> void:
	if item:
		$InteractionMenu.show_menu()
