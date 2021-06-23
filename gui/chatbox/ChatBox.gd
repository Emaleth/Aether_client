extends PanelContainer

onready var edit_line = $VBoxContainer/PanelContainer2/LineEdit
onready var label = $VBoxContainer/PanelContainer/ScrollContainer/Label

func _on_LineEdit_text_entered(new_text: String) -> void:
	label.text += "player > " + new_text + "\n"
	edit_line.clear()
