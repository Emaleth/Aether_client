extends Button

var item = null
var index : int

onready var amount_label := $GridContainer/AmountLabel

onready var tooltip = preload("res://source/ui/tooltip/Tooltip.tscn")


func configure(_item, _index):
	item = _item
	index = _index
	set_dummy_tooltip_text()
	set_item_icon()
	set_amount_label()
	
	
func set_dummy_tooltip_text() -> void:
	hint_tooltip = "text" if item else ""
	
	
func _make_custom_tooltip(_for_text: String) -> Control:
	var new_tooltip = tooltip.instance()
	new_tooltip.conf(item)
	return new_tooltip
				
		
func set_item_icon() -> void:
	if item:
		var item_icon_path = "res://assets/icons/item//%s.svg" % str(item["archetype"])
		icon = load(item_icon_path) if ResourceLoader.exists(item_icon_path) else preload("res://assets/icons/no_icon.svg")
	else:
		icon = null

		
func set_amount_label() -> void:
	if item:
		amount_label.text = "" if item["amount"] == 1 else str(item["amount"])
	else:
		amount_label.text = ""
		
