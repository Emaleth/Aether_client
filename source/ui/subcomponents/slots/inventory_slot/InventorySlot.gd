extends Button

var item = null
var index : int

onready var amount_label := $GridContainer/AmountLabel

onready var tooltip = preload("res://source/ui/tooltips/inventory_tooltip/InventoryTooltip.tscn")
onready var interaction_menu = $InteractionMenu


func configure(_item, _index):
	item = _item
	index = _index
	set_dummy_tooltip_text()
	set_item_icon()
	set_amount_label()
	connect_interaction_menu_signals()
	
	
func set_dummy_tooltip_text() -> void:
	hint_tooltip = "text" if item else ""
	

func connect_interaction_menu_signals():
	interaction_menu.connect("discard", Server, "request_item_discard", [index])
	interaction_menu.connect("equip", Server, "request_item_equip", [index])
	interaction_menu.connect("use", Server, "request_item_use", [index])
	
	
func _make_custom_tooltip(_for_text: String) -> Control:
	var new_tooltip = tooltip.instance()
	new_tooltip.conf(item["item"])
	return new_tooltip
				
		
func set_item_icon() -> void:
	if item:
		var item_icon_path = "res://assets/icons/item//%s.svg" % str(item["item"])
		icon = load(item_icon_path) if ResourceLoader.exists(item_icon_path) else preload("res://assets/icons/no_icon.svg")
	else:
		icon = null

		
func set_amount_label() -> void:
	if item:
		amount_label.text = "" if item["amount"] == 1 else str(item["amount"])
	else:
		amount_label.text = ""
		


func _on_InventorySlot_pressed() -> void:
	if item:
		$InteractionMenu.show_menu()
