extends PanelContainer

var item_id = null
var slot_id = null
var container_type = null

onready var slot_icon =  $HBoxContainer/TextureRect
onready var slot_label = $HBoxContainer/RichTextLabel
onready var interaction_menu = $CenterContainer/InteractionMenu

onready var equip_button : Button = $CenterContainer/InteractionMenu/Equip
onready var unequip_button : Button = $CenterContainer/InteractionMenu/Unequip
onready var discard_button : Button = $CenterContainer/InteractionMenu/Discard
onready var use_button : Button = $CenterContainer/InteractionMenu/Use


func configure(_slot_id, _data, _container_type):
	item_id = _data["item_id"]
	slot_id = _slot_id
	container_type = _container_type
	
	dummy_config()
	
	set_item_icon()
	configure_interaction_menu()
	
	
func dummy_config() -> void:
	interaction_menu.hide()
	hint_tooltip = "text" if item_id else ""
	$Node/Control.hide()
#
#
func configure_interaction_menu():
	if item_id:
		if container_type == "inventory":
			equip_button.show()
			unequip_button.hide()
			discard_button.show()
			use_button.show()
		if container_type == "equipment":
			pass
	
#
#func _make_custom_tooltip(_for_text: String) -> Control:
#	var new_tooltip = tooltip.instance()
#	new_tooltip.conf(item["item"])
#	return new_tooltip
#
#
func set_item_icon() -> void:
	if item_id:
		var item_icon_path = "res://assets/icons/item/%s.svg" % str(item_id)
		slot_icon.icon = load(item_icon_path) if ResourceLoader.exists(item_icon_path) else preload("res://assets/third_party/icons/no_icon.svg")
	else:
		slot_icon.icon = null
#
#
#func set_amount_label() -> void:
#	if item:
#		amount_label.text = "" if item["amount"] == 1 else str(item["amount"])
#	else:
#		amount_label.text = ""


func _on_ItemSlot_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if item_id:
			interaction_menu.show()
			$Node/Control.show()


func _on_Equip_pressed() -> void:
	Server.request_item_equip(slot_id)


func _on_Discard_pressed() -> void:
	Server.request_item_discard(slot_id)


func _on_Use_pressed() -> void:
	Server.request_item_use(slot_id)


func _on_Unequip_pressed() -> void:
	Server.request_item_unequip(slot_id)


func _on_Control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		interaction_menu.hide()
		$Node/Control.hide()
		
			

