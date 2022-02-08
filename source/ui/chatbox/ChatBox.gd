extends PanelContainer

enum {READ, WRITE}

var mode
var small_window_size = Vector2(250, 150)
var big_window_size = Vector2(300, 250)


onready var msg_list := $VBoxContainer/OutputPanel/ScrollContainer/MessageList
onready var template_chat_line := $VBoxContainer/OutputPanel/ScrollContainer/MessageList/Template
onready var input_line := $VBoxContainer/InputPanel/LineEdit
onready var scroll_container = $VBoxContainer/OutputPanel/ScrollContainer
onready var mode_tween := $ModeTween
onready var scroll_tween := $ScrollTween
onready var outer_frame := get_parent()


func _ready() -> void:
	Server.connect("s_update_chat_state", self, "update_chat_box")
	template_chat_line.hide()
	change_mode(READ)
	rect_min_size = small_window_size
	rect_size = small_window_size

	
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
	change_mode(READ)


func _unhandled_key_input(_event: InputEventKey) -> void:
	if Input.is_action_just_pressed("chat"):
		change_mode(WRITE)


func change_mode(_mode):
	match _mode:
		READ:
			GlobalVariables.chatting = false
			input_line.release_focus()
			make_small()
		WRITE:
			GlobalVariables.chatting = true
			input_line.grab_focus()
			make_big()
			
	mode = _mode


func make_small() -> void:
	mode_tween.remove_all()
	mode_tween.interpolate_property(
			self, 
			"rect_size", 
			rect_size, 
			small_window_size, 
			0.3, 
			Tween.TRANS_QUAD, 
			Tween.EASE_OUT)
	mode_tween.interpolate_property(
			self, 
			"rect_position:y", 
			rect_position.y, 
			outer_frame.rect_size.y - small_window_size.y, 
			0.3, 
			Tween.TRANS_QUAD, 
			Tween.EASE_OUT)
	mode_tween.start()
	

func make_big() -> void:
	mode_tween.remove_all()
	mode_tween.interpolate_property(
			self, 
			"rect_size", 
			rect_size, 
			big_window_size, 
			0.3,  
			Tween.TRANS_QUAD, 
			Tween.EASE_OUT)
	mode_tween.interpolate_property(
			self, 
			"rect_position:y", 
			rect_position.y, 
			outer_frame.rect_size.y - big_window_size.y, 
			0.3,  
			Tween.TRANS_QUAD, 
			Tween.EASE_OUT)
	mode_tween.start()
