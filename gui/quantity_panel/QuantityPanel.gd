extends PanelContainer

var quantity = 1
var max_q = 0
var s
var t

onready var line = $VBoxContainer/HBoxContainer/LineEdit

signal send_quantity

func conf(slot, source, target):
	quantity = 1
	s = source
	t = target
	max_q = source[0].get(source[1])[source[2]].quantity
	connect("send_quantity", slot, "split")
	line.text = str(quantity)
	show()
	
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

func _unhandled_key_input(_event: InputEventKey) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("send_quantity", self, s, t, quantity)
		hide()
		
func _on_Accept_pressed() -> void:
	emit_signal("send_quantity", self, s, t, quantity)
	hide()

func _on_VBoxContainer_sort_children() -> void:
	var offset = 4
	$Close.rect_position = Vector2(rect_size.x - $Close.rect_size.x / 2 - offset, -$Close.rect_size.y / 2 + offset) 

func _on_Close_pressed() -> void:
	emit_signal("send_quantity", self, s, t, 0)
	hide()

func _on_QuantityPanel_modal_closed() -> void:
	emit_signal("send_quantity", self, s, t, 0)

