extends PanelContainer

var item = null
var container = null
var shortcut = null
var index : int
var alternative := false
var tmp_cd := 0.0

onready var item_texture := $VBoxContainer/PanelContainer/Icon
onready var amount_label := $VBoxContainer/PanelContainer/GridContainer/AmountLabel
onready var shortcut_label := $VBoxContainer/PanelContainer/GridContainer/ShortcutLabel
onready var price_label := $VBoxContainer/PricePanel/PriceLabel
onready var cooldown_progress := $VBoxContainer/PanelContainer/TextureProgress
onready var cooldown_tween := $VBoxContainer/PanelContainer/TextureProgress/Tween
onready var cooldown_lable := $VBoxContainer/PanelContainer/CooldownLabel

onready var preview = preload("res://source/ui/drag_preview/DragPreview.tscn")
onready var tooltip = preload("res://source/ui/tooltip/Tooltip.tscn")


func configure(_item, _container, _index, _shortcut, _show_msrp):
	item = _item
	container = _container
	shortcut = _shortcut
	index = _index
	set_tooltip_text()
	set_item_icon()
	set_amount_label()
	set_shortcut_label()
	set_price_label(_show_msrp)
	set_cooldown()
	
	
func set_tooltip_text() -> void:
	hint_tooltip = "text" if item else ""


func set_cooldown():
	if item == null or container == "shop": 
		cooldown_progress.hide()
		cooldown_lable.hide()
		return 
	var current_time = Server.client_clock
	var ability = LocalDataTables.item_table[item["archetype"]]["action"]
	if ability == null: 
		cooldown_progress.hide()
		cooldown_lable.hide()
		return
	var ability_data = LocalDataTables.skill_table[LocalDataTables.item_table[item["archetype"]]["action"]] 
	var tmp_cd = (float(ability_data["cooldown"]) * 1000) - (current_time - item["last_used"])
	if tmp_cd > 0:
		cooldown_tween.remove_all()
		cooldown_tween.interpolate_property(
				cooldown_progress,
				"value",
				100,
				0,
				tmp_cd / 1000.0,
				Tween.TRANS_LINEAR, 
				Tween.EASE_IN)
		cooldown_tween.interpolate_property(
				self,
				"tmp_cd",
				tmp_cd,
				0,
				tmp_cd / 1000.0,
				Tween.TRANS_LINEAR, 
				Tween.EASE_IN)
		cooldown_tween.start()
		cooldown_progress.show()
		cooldown_lable.show()
		
	else:
		cooldown_lable.hide()
		cooldown_progress.hide()
	
	
func _make_custom_tooltip(_for_text: String) -> Control:
	var new_tooltip = tooltip.instance()
	new_tooltip.conf(item)
	return new_tooltip
		
		
func set_price_label(_show) -> void:
	if _show:
		if item:
			price_label.text = str(LocalDataTables.item_table[item["archetype"]]["msrp"]) if LocalDataTables.item_table[item["archetype"]].has("msrp") else "?"
		else:
			price_label.text = ""
	else:
		$VBoxContainer/PricePanel.hide()
		
		
func set_item_icon() -> void:
	if item:
		var item_icon_path = "res://assets/icons/item//%s.svg" % str(item["archetype"]) if alternative == false else "res://assets/icons/abilities//%s.svg" % str(LocalDataTables.item_table[item["archetype"]]["action"])
		item_texture.texture = load(item_icon_path) if ResourceLoader.exists(item_icon_path) else preload("res://assets/icons/no_icon.svg")
	else:
		item_texture.texture = null


func set_shortcut_label() -> void:
	if shortcut and InputMap.get_action_list(shortcut).size() != 0:
		shortcut_label.text = InputMap.get_action_list(shortcut)[0].as_text() if shortcut else ""
	else:
		shortcut_label.text = ""
		
		
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
			"shop_id" : GlobalVariables.interactable.name if container == "shop" and GlobalVariables.interactable else null,
			"is_multi" : LocalDataTables.item_table[item["archetype"]]["max_stack"] if LocalDataTables.item_table[item["archetype"]]["max_stack"] > 1 else null
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
		"shop_id" : GlobalVariables.interactable.name if container == "shop" and GlobalVariables.interactable else null
	}
	
	
	if data["container"] == "shop" and _data["container"] == "inventory" and data["shop_id"] != null:
		if Input.is_action_pressed("mod") and _data["amount"] > 1:
			GlobalVariables.user_interface.SL_amount_popup.conf(_data, data, true, true)
		else:
			Server.request_item_sell(data["shop_id"], _data["index"])
	
	elif data["container"] == "inventory" and _data["container"] == "shop" and _data["shop_id"] != null:
		if Input.is_action_pressed("mod") and _data["is_multi"] != null:
			GlobalVariables.user_interface.SL_amount_popup.conf(_data, data, true, false)
		else:
			Server.request_item_buy(_data["shop_id"], _data["index"])
	
	elif data["container"] != "shop" and _data["container"] != "shop":
		if Input.is_action_pressed("mod") and _data["amount"] > 1:
			GlobalVariables.user_interface.ML_amount_popup.conf(_data, data)
		else:
			Server.request_item_transfer(_data, -1, data)
	else:
		print("WTF?!")
	
	
func _unhandled_key_input(_event: InputEventKey) -> void:
	if !shortcut or !item:
		return
	if Input.is_action_just_pressed(shortcut):
		var data = {
			"container" : container,
			"index" : index
		}
		Server.send_item_use_request(data)


func _on_Tween_tween_all_completed() -> void:
	cooldown_progress.hide()
	cooldown_lable.hide()


func _on_Tween_tween_step(object: Object, key: NodePath, elapsed: float, value: Object) -> void:
	cooldown_lable.text = str(round(tmp_cd))
