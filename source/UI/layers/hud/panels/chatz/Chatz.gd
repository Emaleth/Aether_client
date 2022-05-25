extends PanelContainer


onready var msg_list := $VBoxContainer/OutputPanel/ScrollContainer/VBoxContainer
onready var template_chat_line := $VBoxContainer/OutputPanel/ScrollContainer/VBoxContainer/Template
onready var input_line := $VBoxContainer/InputPanel/LineEdit
onready var scroll_container = $VBoxContainer/OutputPanel/ScrollContainer
onready var scroll_tween := $Tween

func _ready() -> void:
#	Server.connect("s_update_chat_state", self, "update_chat_box")
	template_chat_line.hide()

	
func format_chat_timestamp(_timestamp):
	var date_dict := OS.get_datetime_from_unix_time(_timestamp / 1000)
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
	var formatted_timestamp := "[%s:%s]" % [hour, minute]
	
	return formatted_timestamp


func update_chat_box(_chat_state):
	for i in _chat_state:
		var sender : String = str(i[0])
		var timestamp : int = int(i[1])
		var message : String = i[2]
		var new_line = template_chat_line.duplicate()
		new_line.get_node("HBoxContainer/Timestamp").text = format_chat_timestamp(timestamp)
		new_line.get_node("HBoxContainer/Sender").text = "%s: " % str(sender)
		new_line.get_node("Message").text = str(message)
		msg_list.add_child(new_line)
		new_line.show()
		scroll_to_new_msg()


func scroll_to_new_msg() -> void:
	var new_scroll_v := 0.0
	for i in msg_list.get_children(): 
		new_scroll_v += i.rect_size.x
	scroll_tween.remove_all()
	scroll_tween.interpolate_property(
			scroll_container, 
			"scroll_vertical", 
			scroll_container.scroll_vertical, 
			new_scroll_v, 
			new_scroll_v * 0.003, 
			Tween.TRANS_QUAD, 
			Tween.EASE_OUT)
	scroll_tween.start()
	
	
func _on_LineEdit_text_entered(new_text: String) -> void:
	if new_text != "":
		Server.send_chat_message(new_text)
	input_line.clear()

