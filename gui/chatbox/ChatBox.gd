extends PanelContainer

onready var edit_line : LineEdit = $VBoxContainer/PanelContainer2/LineEdit
onready var label = $VBoxContainer/PanelContainer/ScrollContainer/Label


func _on_LineEdit_text_entered(new_text: String) -> void:
	new_msg("player", new_text)
	edit_line.clear()
	edit_line.release_focus()

func new_msg(sender, text):
	text = filter_filth(text)
	label.text += sender + " > " + text + "\n"

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("chat"):
		if not edit_line.has_focus():
			edit_line.grab_focus()

func filter_filth(text) -> String:
	text += " <- [message filtered]"
	return text
