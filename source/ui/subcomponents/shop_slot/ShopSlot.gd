extends PanelContainer

var item = null
var container = null
var index : int
var shop_id = null

onready var item_texture := $VBoxContainer/PanelContainer/Icon
onready var price_label := $VBoxContainer/PanelContainer2/price

onready var preview = preload("res://source/ui/drag_preview/DragPreview.tscn")
onready var tooltip = preload("res://source/ui/tooltip/Tooltip.tscn")


func configure(_item, _container, _index):
	item = _item
	container = _container
	index = _index
	set_tooltip_text()
	set_item_icon()
	
	
func set_tooltip_text() -> void:
	hint_tooltip = "text" if item else ""


func _make_custom_tooltip(_for_text: String) -> Control:
	var new_tooltip = tooltip.instance()
	new_tooltip.conf(item)
	return new_tooltip
		
		
func set_item_icon() -> void:
	if item:
		var item_icon_path = "res://assets/icons/item//%s.svg" % str(item["archetype"])
		item_texture.texture = load(item_icon_path) if ResourceLoader.exists(item_icon_path) else preload("res://assets/icons/item/no_icon.svg")
	else:
		item_texture.texture = null


func set_shortcut_label() -> void:
	if LocalDataTables.item_table[item["archetype"]].has("msrp"):
		price_label.text = LocalDataTables.item_table[item["archetype"]]["msrp"]
	else:
		price_label.text = ""
		
		
func get_drag_data(_position: Vector2):
	if item != null:
		var data := {
			"container" : container,
			"index" : index,
			"amount" : item["amount"],
			"shop_id" : shop_id
		}
		var new_preview = preview.instance()
		new_preview.conf(item)
		set_drag_preview(new_preview)

		return data


func can_drop_data(_position: Vector2, _data) -> bool:
	return true
	
	
func drop_data(_position: Vector2, _data) -> void:
	var data = {
		"container" : container,
		"index" : index,
		"amount" : item["amount"] if item else null,
		"shop_id" : shop_id
		 
	}
#	if Input.is_action_pressed("mod") and _data["amount"] > 1:
#		GlobalVariables.user_interface.SL_amount_popup.conf(_data, data)
#	else:
	if data["container"] == "shop":
		Server.request_item_sell(data["shop_id"], _data["index"])
	else:
		Server.request_item_buy(_data["shop_id"], data["index"])
