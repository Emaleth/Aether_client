extends CanvasLayer

# DEBUG PANELS
onready var latency_label = $MarginContainer/DebugInfoPanels/Latency/Label
onready var target_label = $MarginContainer/DebugInfoPanels/Target/Label
# resource bars
onready var health_bar = $MarginContainer/BottomMiddlePanel/BottomMiddle/HBoxContainer/HealthBar
onready var mana_bar = $MarginContainer/BottomMiddlePanel/BottomMiddle/HBoxContainer/ManaBar
# chat
onready var chat_box = $MarginContainer/BottomLeftPanel/VBoxContainer/ChatBox
onready var msg_list = $MarginContainer/BottomLeftPanel/VBoxContainer/ChatBox/PanelContainer/MsgList
onready var template_chat_line = $MarginContainer/BottomLeftPanel/VBoxContainer/ChatBox/PanelContainer/MsgList/Template
onready var input_line = $MarginContainer/BottomLeftPanel/VBoxContainer/LineEdit
# TOP RIGHT
onready var minimap = $MarginContainer/TopRightPanel/VBoxContainer/PanelContainer/Minimap
onready var minimap_camera_pivot = $MarginContainer/TopRightPanel/VBoxContainer/PanelContainer/Viewport/Spatial
onready var clock_label = $MarginContainer/TopRightPanel/VBoxContainer/ServerClock/Label

var target = null


func _ready() -> void:
	Server.connect("s_update_chat_state", self, "update_chat_box")
	template_chat_line.hide()
	
func _physics_process(_delta: float) -> void:
	format_time()
	latency_label.text = "Latency: %sms" % (Server.latency)

func format_time():
	var date_dict = OS.get_datetime_from_unix_time(Server.client_clock / 1000)
	var hour : String
	var minute : String
	var second : String
	if date_dict["hour"] < 10:
		hour = "0" + str(date_dict["hour"])
	else:
		hour = str(date_dict["hour"])
		
	if date_dict["minute"] < 10:
		minute = "0" + str(date_dict["minute"])
	else:
		minute = str(date_dict["minute"])
		
	if date_dict["second"] < 10:
		second = "0" + str(date_dict["second"])
	else:
		second = str(date_dict["second"])
		
	clock_label.text = "%s:%s:%s" % [hour, minute, second]
	
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
			
func update_health_bar(_hp, _max_hp):
	health_bar.update_ui(_hp, _max_hp)
	
func update_mana_bar(_mana, _max_mana):
	mana_bar.update_ui(_mana, _max_mana)

func update_chat_box(chat_state):
	for i in chat_state:
		var sender = i[0]
		var timestamp = i[1]
		var message = i[2]
		var new_line = template_chat_line.duplicate()
		new_line.get_node("Timestamp").text = format_chat_timestamp(timestamp)
		new_line.get_node("Sender").text = "%s: " % str(sender)
		new_line.get_node("Message").text = str(message)
		msg_list.add_child(new_line)
		new_line.show()

func _on_LineEdit_text_entered(new_text: String) -> void:
	Server.send_chat_msg(new_text)
	input_line.clear()
	
func show_tooltip(_target):
	target = _target
	target_label.text = "Mouse Target: %s" % _target 

func _on_SkillSlot_pressed() -> void:
	get_parent().shoot_bullet("fireball", target)

func _on_SkillSlot2_pressed() -> void:
	get_parent().shoot_bullet("ice_bolt", target)


func _on_Button_pressed() -> void:
	get_parent().shoot_bullet("fireball", target)
