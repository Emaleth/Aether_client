extends "res://source/ui/subcomponents/window/Window.gd"

onready var msg_list = $VBoxContainer/OutputPanel/ScrollContainer/MessageList
onready var template_chat_line = $VBoxContainer/OutputPanel/ScrollContainer/MessageList/Template
onready var input_line = $VBoxContainer/InputPanel/LineEdit


func _ready() -> void:
	Server.connect("s_update_chat_state", self, "update_chat_box")
	template_chat_line.hide()
	
func format_chat_timestamp(_timestamp):
	var date_dict = OS.get_datetime_from_unix_time(_timestamp / 1000)
	var hour : String
	var minute : String
	if date_dict["hour"] < 10:
		hour = "0" + str(date_dict["hour"])
	else:
		hour = str(date_dict["hour"])
		
	if date_dict["minute"] < 10:
		minute = "0" + str(date_dict["minute"])
	else:
		minute = str(date_dict["minute"])
	var formatted_timestamp = "[%s:%s]" % [hour, minute]
	
	return formatted_timestamp

func update_chat_box(_chat_state):
	for i in _chat_state:
		var sender = i[0]
		var timestamp = i[1]
		var message = i[2]
		var new_line = template_chat_line.duplicate()
		new_line.get_node("Timestamp").text = format_chat_timestamp(timestamp)
		new_line.get_node("Sender").text = "%s: " % str(sender)
		new_line.get_node("Message").text = str(message)
		msg_list.add_child(new_line)
		new_line.show()
		# MAKE IT SCROLL TO THE BOTTOM

func _on_LineEdit_text_entered(new_text: String) -> void:
	Server.send_chat_message(new_text)
	input_line.clear()
	input_line.release_focus()
