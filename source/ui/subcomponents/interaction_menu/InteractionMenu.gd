extends CanvasLayer


onready var button_menu = $VBoxContainer

export var equip_action_allowed := false
export var unequip_action_allowed := false
export var discard_action_allowed := false
export var use_action_allowed := false
export var craft_action_allowed := false

signal equip
signal unequip
signal discard
signal use
signal craft


func _ready() -> void:
	for i in get_children():
		i.hide()
	if equip_action_allowed:
		$VBoxContainer/Equip.show()
		$VBoxContainer/Equip.disabled = false
	else:
		$VBoxContainer/Equip.hide()
		$VBoxContainer/Equip.disabled = true
	if unequip_action_allowed:
		$VBoxContainer/Unequip.show()
		$VBoxContainer/Unequip.disabled = false
	else:
		$VBoxContainer/Unequip.hide()
		$VBoxContainer/Unequip.disabled = true
	if discard_action_allowed:
		$VBoxContainer/Discard.show()
		$VBoxContainer/Discard.disabled = false
	else:
		$VBoxContainer/Discard.hide()
		$VBoxContainer/Discard.disabled = true
	if use_action_allowed:
		$VBoxContainer/Use.show()
		$VBoxContainer/Use.disabled = false
	else:
		$VBoxContainer/Use.hide()
		$VBoxContainer/Use.disabled = true
	if craft_action_allowed:
		$VBoxContainer/Craft.show()
		$VBoxContainer/Craft.disabled = false
	else:
		$VBoxContainer/Craft.hide()
		$VBoxContainer/Craft.disabled = true
				
	
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


func _on_Control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		for i in get_children():
			i.hide()