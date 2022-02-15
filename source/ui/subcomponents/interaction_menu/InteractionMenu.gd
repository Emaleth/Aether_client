extends CanvasLayer


onready var button_menu = $VBoxContainer

signal equip
signal unequip
signal discard


func _ready() -> void:
	for i in get_children():
		i.hide()
	
	
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


func _on_Control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		for i in get_children():
			i.hide()

