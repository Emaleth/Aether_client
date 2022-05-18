extends CanvasLayer


onready var button_menu = $VBoxContainer

export var equip_action_allowed := false
export var unequip_action_allowed := false
export var discard_action_allowed := false
export var use_action_allowed := false
export var craft_action_allowed := false
export var loot_action_allowed := false
export var buy_action_allowed := false
export var sell_action_allowed := false
export var pin_action_allowed := false

signal equip
signal unequip
signal discard
signal use
signal craft
signal loot
signal buy
signal sell
signal pin

func _ready() -> void:
	for i in get_children():
		i.hide()

	$VBoxContainer/Equip.visible = equip_action_allowed
	$VBoxContainer/Equip.disabled = not equip_action_allowed

	$VBoxContainer/Unequip.visible = unequip_action_allowed
	$VBoxContainer/Unequip.disabled = not unequip_action_allowed

	$VBoxContainer/Discard.visible = discard_action_allowed
	$VBoxContainer/Discard.disabled = not discard_action_allowed

	$VBoxContainer/Use.visible = use_action_allowed
	$VBoxContainer/Use.disabled = not use_action_allowed

	$VBoxContainer/Craft.visible = craft_action_allowed
	$VBoxContainer/Craft.disabled = not craft_action_allowed

	$VBoxContainer/Loot.visible = loot_action_allowed
	$VBoxContainer/Loot.disabled = not loot_action_allowed

	$VBoxContainer/Buy.visible = buy_action_allowed
	$VBoxContainer/Buy.disabled = not buy_action_allowed

	$VBoxContainer/Sell.visible = sell_action_allowed
	$VBoxContainer/Sell.disabled = not sell_action_allowed

	$VBoxContainer/Pin.visible = pin_action_allowed
	$VBoxContainer/Pin.disabled = not pin_action_allowed
	
	
func show_menu():
	button_menu.rect_global_position = (get_parent().rect_global_position + get_parent().rect_size / 2)
	for i in get_children():
		i.show()

	
func _on_Equip_pressed() -> void:
	emit_signal("equip")
	for i in get_children():
		i.hide()


func _on_Unequip_pressed() -> void:
	emit_signal("unequip")
	for i in get_children():
		i.hide()


func _on_Discard_pressed() -> void:
	emit_signal("discard")
	for i in get_children():
		i.hide()


func _on_Use_pressed() -> void:
	emit_signal("use")
	for i in get_children():
		i.hide()


func _on_Craft_pressed() -> void:
	emit_signal("craft")
	for i in get_children():
		i.hide()


func _on_Loot_pressed() -> void:
	emit_signal("loot")
	for i in get_children():
		i.hide()


func _on_Buy_pressed() -> void:
	emit_signal("buy")
	for i in get_children():
		i.hide()


func _on_Sell_pressed() -> void:
	emit_signal("sell")
	for i in get_children():
		i.hide()
		
		
func _on_Pin_pressed() -> void:
	emit_signal("pin")
	for i in get_children():
		i.hide()
		
		
func _on_Control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		for i in get_children():
			i.hide()
