extends Button

var item = null
var index : int

var shop_id : int
onready var tooltip = preload("res://source/ui/tooltips/inventory_tooltip/InventoryTooltip.tscn")
onready var interaction_menu = $InteractionMenu


func configure(_item, _index, _shop_id):
	item = _item
	index = _index
	set_dummy_tooltip_text()
	set_item_icon()
	connect_interaction_menu_signals()
	
	
func set_dummy_tooltip_text() -> void:
	hint_tooltip = "text" if item else ""
	

func connect_interaction_menu_signals():
	interaction_menu.connect("buy", Server, "request_item_buy", [shop_id, index])
	
	
func _make_custom_tooltip(_for_text: String) -> Control:
	var new_tooltip = tooltip.instance()
	new_tooltip.conf(item)
	return new_tooltip
				
		
func set_item_icon() -> void:
	if item:
		var item_icon_path = "res://assets/icons/item//%s.svg" % str(item)
		icon = load(item_icon_path) if ResourceLoader.exists(item_icon_path) else preload("res://assets/icons/no_icon.svg")
	else:
		icon = null


func _on_InventorySlot_pressed() -> void:
	if item:
		$InteractionMenu.show_menu()
