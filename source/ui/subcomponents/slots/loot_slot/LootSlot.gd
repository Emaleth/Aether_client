extends Button

var item = null
var index : int
var npc_id : int

onready var amount_label := $GridContainer/AmountLabel

onready var tooltip = preload("res://source/ui/tooltips/inventory_tooltip/InventoryTooltip.tscn")
onready var interaction_menu = $InteractionMenu


func configure(_item, _npc_id, _index):
	item = _item
	index = _index
	npc_id = _npc_id
	set_dummy_tooltip_text()
	set_item_icon()
	set_amount_label()
	connect_interaction_menu_signals()
	
	
func set_dummy_tooltip_text() -> void:
	hint_tooltip = "text" if item else ""
	

func connect_interaction_menu_signals():
	interaction_menu.connect("loot", Server, "request_loot_pickup", [npc_id, index])
	
	
func _make_custom_tooltip(_for_text: String) -> Control:
	var new_tooltip = tooltip.instance()
	new_tooltip.conf(item)
	return new_tooltip
				
		
func set_item_icon() -> void:
	if item:
		var item_icon_path = "res://assets/icons/item//%s.svg" % str(item.keys()[0])
		icon = load(item_icon_path) if ResourceLoader.exists(item_icon_path) else preload("res://assets/icons/no_icon.svg")
	else:
		icon = null

		
func set_amount_label() -> void:
	if item:
		amount_label.text = "" if item.values()[0] == 1 else str(item.values()[0])
	else:
		amount_label.text = ""
		

func _on_InventorySlot_pressed() -> void:
	if item:
		$InteractionMenu.show_menu()
