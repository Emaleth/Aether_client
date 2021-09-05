extends CanvasLayer

# clock
onready var clock_label = $ServerClock/Clock
# resource bars
onready var health_bar = $ResourceBars/HealthBar
onready var mana_bar = $ResourceBars/ManaBar
# chat
onready var chat_box = $ChatBox
onready var msg_list = $ChatBox/VBoxContainer/PanelContainer/MsgList
onready var template_chat_line = $ChatBox/VBoxContainer/PanelContainer/MsgList/Template
onready var input_line = $ChatBox/VBoxContainer/LineEdit
var chat = false

func _ready() -> void:
	Server.connect("s_update_chat_state", self, "update_chat_box")
	template_chat_line.hide()
	
func _physics_process(_delta: float) -> void:
	var date_dict = OS.get_datetime_from_unix_time(Server.client_clock / 1000)
	clock_label.text = "Server Time: %s:%s:%s" % [date_dict["hour"], date_dict["minute"], date_dict["second"]]

func _unhandled_key_input(event: InputEventKey) -> void:
	if Input.is_action_just_pressed("chat"):
		if not input_line.has_focus():
			chat = true
			input_line.grab_focus()
		
func update_health_bar(hp, max_hp = null):
	if max_hp != null:
		health_bar.max_value = max_hp
	health_bar.value = hp
	
func update_mana_bar(mana, max_mana = null):
	if max_mana != null:
		mana_bar.max_value = max_mana
	mana_bar.value = mana

func update_chat_box(chat_state):
	for i in chat_state:
		var sender = i[0]
		var timestamp = i[1]
		var message = i[2]
		var new_line = template_chat_line.duplicate()
		var date_dict = OS.get_datetime_from_unix_time(timestamp / 1000)
		new_line.get_node("Timestamp").text = str("[%s:%s:%s]" % [date_dict["hour"], date_dict["minute"], date_dict["second"]])
		new_line.get_node("Sender").text = "[%s]" % str(sender)
		new_line.get_node("Message").text = str(message)
		msg_list.add_child(new_line)
		new_line.show()

func _on_LineEdit_text_entered(new_text: String) -> void:
	Server.send_chat_msg(new_text)
	input_line.clear()
	input_line.release_focus()
	chat = false
