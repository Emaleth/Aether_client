extends Popup

var quantity = 1
var max_q = 0
var s
var t

onready var line = $MarginContainer/VBoxContainer/HBoxContainer/LineEdit

signal send_quantity

func conf(slot, source, target):
	quantity = 1
	s = source
	t = target
	max_q = source[0].get(source[1])[source[2]].quantity
	connect("send_quantity", slot, "split")
	line.text = str(quantity)
	show_modal()
	
func _on_More_pressed() -> void:
	quantity = min(quantity +1, max_q)
	line.text = str(quantity)

func _on_Less_pressed() -> void:
	quantity = max(quantity - 1, 0)
	line.text = str(quantity)

func _on_LineEdit_text_changed(new_text: String) -> void:
	var c = line.caret_position
	quantity = clamp(int(new_text), 0, max_q)
	line.text = str(quantity)
	line.caret_position = c

func _on_LineEdit_text_entered(_new_text: String) -> void:
	emit_signal("send_quantity", self, s, t, quantity)
	hide()

func _unhandled_key_input(event: InputEventKey) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("send_quantity", self, s, t, quantity)
		hide()
		
func _on_Accept_pressed() -> void:
	emit_signal("send_quantity", self, s, t, quantity)
	hide()

func _on_Cancel_pressed() -> void:
	emit_signal("send_quantity", self, s, t, quantity)
	hide()
