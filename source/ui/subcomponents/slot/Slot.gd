extends PanelContainer

enum {ITEM, SPELL, SHOP}
var mode : int

var item = null
var container = null
var shortcut = null
var index : int

onready var item_texture := $VBoxContainer/PanelContainer/Icon
onready var amount_label := $VBoxContainer/PanelContainer/GridContainer/AmountLabel
onready var shortcut_label := $VBoxContainer/PanelContainer/GridContainer/ShortcutLabel
onready var price_label := $VBoxContainer/Price

onready var preview = preload("res://source/ui/drag_preview/DragPreview.tscn")
onready var tooltip = preload("res://source/ui/tooltip/Tooltip.tscn")


func configure(_item, _container, _index, _shortcut, _mode):
	item = _item
	container = _container
	shortcut = _shortcut
	index = _index
	mode = _mode
	set_tooltip_text()
	set_item_icon()
	set_amount_label()
	set_shortcut_label()
	set_price_label()
	
	
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
	if shortcut and InputMap.get_action_list(shortcut).size() != 0:
		shortcut_label.text = InputMap.get_action_list(shortcut)[0].as_text() if shortcut else ""
	else:
		shortcut_label.text = ""
		
		
func set_price_label() -> void:
	if mode == SHOP:
		price_label.text = "3"
	else:
		price_label.hide()
		
		
func set_amount_label() -> void:
	if item:
		amount_label.text = "" if item["amount"] == 1 else str(item["amount"])
	else:
		amount_label.text = ""
		
		
func get_drag_data(_position: Vector2):
	if item != null:
		var data := {
			"container" : container,
			"index" : index,
			"amount" : item["amount"],
			"mode" : mode
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
		"amount" : item["amount"] if item else null 
	}
	if Input.is_action_pressed("mod") and _data["amount"] > 1:
		if _data["mode"] == SHOP:
			GlobalVariables.user_interface.SL_amount_popup.conf(_data, data)
		else:
			GlobalVariables.user_interface.ML_amount_popup.conf(_data, data)
	else:
		Server.request_item_transfer(_data, -1, data)
	
	
func _unhandled_key_input(_event: InputEventKey) -> void:
	if !shortcut or !item:
		return
	if Input.is_action_just_pressed(shortcut):
		var data = {
			"container" : container,
			"index" : index
		}
		Server.send_item_use_request(data)
