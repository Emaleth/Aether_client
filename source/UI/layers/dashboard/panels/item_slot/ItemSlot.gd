extends PanelContainer

var container_type = null
var slot_id = null
var item_data = null

onready var slot_icon : TextureRect =  $VBoxContainer/HBoxContainer/TextureRect
onready var name_label : Label = $VBoxContainer/HBoxContainer/NameLabel
onready var amount_label : Label = $VBoxContainer/HBoxContainer/AmountLabel
onready var interaction_menu = $VBoxContainer/InteractionMenu

onready var equip_button : Button = $VBoxContainer/InteractionMenu/Equip
onready var unequip_button : Button = $VBoxContainer/InteractionMenu/Unequip
onready var discard_button : Button = $VBoxContainer/InteractionMenu/Discard
onready var use_button : Button = $VBoxContainer/InteractionMenu/Use


func _ready() -> void:
	dummy_config()
	set_item_icon()
	configure_interaction_menu()

	
func configure(_slot_id, _data, _container_type):
	if _data != null:
		slot_id = _slot_id
		item_data = _data
		container_type = _container_type
		
	
func dummy_config() -> void:
	interaction_menu.hide()
	hint_tooltip = "text" if item_data else ""
	$Node/Control.hide()
#
#
func configure_interaction_menu():
	if item_data:
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
	if item_data:
		var item_icon_path = "res://assets/icons/item/%s.svg" % str(item_data["item_id"])
		slot_icon.texture = load(item_icon_path) if ResourceLoader.exists(item_icon_path) else preload("res://assets/third_party/icons/no_icon.svg")
	else:
		slot_icon.texture = null


func set_name_label() -> void:
	if item_data:
		name_label.text = item_data["item_id"]
	else:
		name_label.text = ""

#
func set_amount_label() -> void:
	if item_data:
		amount_label.text = item_data["amount"] if int(item_data["amount"]) > 1 else ""
	else:
		amount_label.text = ""


func _on_ItemSlot_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if item_data:
			interaction_menu.show()
			$Node/Control.show()


func _on_Equip_pressed() -> void:
	Server.request_item_equip(slot_id)
	interaction_menu.hide()
	$Node/Control.hide()


func _on_Discard_pressed() -> void:
	Server.request_item_discard(slot_id)
	interaction_menu.hide()
	$Node/Control.hide()


func _on_Use_pressed() -> void:
	Server.request_item_use(slot_id)
	interaction_menu.hide()
	$Node/Control.hide()
	

func _on_Unequip_pressed() -> void:
	Server.request_item_unequip(slot_id)
	interaction_menu.hide()
	$Node/Control.hide()


func _on_Control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		interaction_menu.hide()
		$Node/Control.hide()
		
			

