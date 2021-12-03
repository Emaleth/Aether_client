extends PanelContainer

var data_a := {}
var data_b := {}
var amount := 1
var max_amount := 1
var min_amount := 1

onready var line_edit = $VBoxContainer/HBoxContainer/LineEdit


func _ready() -> void:
	hide()
	
func conf(_data_a, _data_b):
	data_a = _data_a
	data_b = _data_b
	line_edit.text = str(amount)
# warning-ignore:narrowing_conversion
	max_amount = max(data_a["amount"] - 1, 1)
	show()
	raise()

func _on_Less_pressed() -> void:
	if data_a.size() != 0:
# warning-ignore:narrowing_conversion
		amount = clamp(amount - 1 , min_amount, max_amount)
		line_edit.text = str(amount)

func _on_More_pressed() -> void:
	if data_a.size() != 0:
# warning-ignore:narrowing_conversion
		amount = clamp(amount + 1, min_amount, max_amount)
		line_edit.text = str(amount)

func _on_Confirm_pressed() -> void:
	if data_a.size() != 0:
		Server.request_item_transfer(data_a, amount, data_b)
	line_edit.clear()
	data_a = {}
	data_b = {}
	amount = 1
	hide()
	
func _on_LineEdit_text_entered(_new_text: String) -> void:
	_on_Confirm_pressed()

func _on_LineEdit_text_changed(new_text: String) -> void:
	var new_amount = new_text.to_int()
	new_amount = clamp(new_amount, min_amount, max_amount)
	line_edit.text = str(new_amount)
	line_edit.caret_position = str(new_amount).length()
	amount = int(new_text)

