extends PanelContainer

onready var edit_line : LineEdit = $VBoxContainer/PanelContainer2/LineEdit
onready var label = $VBoxContainer/PanelContainer/ScrollContainer/Label


func _on_LineEdit_text_entered(new_text: String) -> void:
	Server.send_chat_msg(new_text)
	edit_line.clear()
	edit_line.release_focus()

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("chat"):
		if not edit_line.has_focus():
			edit_line.grab_focus()

func add_msgs(msgs):
	for i in msgs:
		label.text += str(i) + "\n"
