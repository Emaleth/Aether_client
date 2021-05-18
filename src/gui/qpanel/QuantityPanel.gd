extends PanelContainer

var quantity = 0

onready var line = $MarginContainer/VBoxContainer/HBoxContainer/LineEdit

func conf(max_q : int):
	line.text = str(quantity)
	show()
	
func _on_More_pressed() -> void:
	quantity = min(quantity +1, 999)
	line.text = str(quantity)

func _on_Less_pressed() -> void:
	quantity = max(quantity - 1, 0)
	line.text = str(quantity)

func _on_LineEdit_text_changed(new_text: String) -> void:
	var c = line.caret_position
	quantity = clamp(int(new_text), 0, 999)
	line.text = str(quantity)
	line.caret_position = c

func _on_LineEdit_text_entered(_new_text: String) -> void:
	pass # Replace with function body.

func _on_Accept_pressed() -> void:
	pass # Replace with function body.

func _on_Cancel_pressed() -> void:
	quantity = 0
	hide()
