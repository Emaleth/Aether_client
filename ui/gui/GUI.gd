extends CanvasLayer

# clock
onready var clock_label = $ServerClock/Clock
# resource bars
onready var health_bar = $ResourceBars/HealthBar
onready var mana_bar = $ResourceBars/ManaBar
# chat
onready var chat_box = $ChatBox
onready var msg_list = $ChatBox/MsgList
onready var template_chat_line = $ChatBox/MsgList/Template


func _ready() -> void:
	Server.connect("s_update_chat_state", self, "update_chat_box")
	template_chat_line.hide()
	
func _physics_process(_delta: float) -> void:
	var date_dict = OS.get_datetime_from_unix_time(Server.client_clock / 1000)
	clock_label.text = "Server Time: %s:%s:%s" % [date_dict["hour"], date_dict["minute"], date_dict["second"]]

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
		var timestamp = chat_state[i][0]
		var sender = chat_state[i][1]
		var message = chat_state[i][2]
		var new_line = template_chat_line.duplicate()
		new_line.get_node("Sender").text = sender
		new_line.get_node("Message").text = message
		new_line.get_node("Timestamp").text = timestamp
		msg_list.add_child(new_line)
		new_line.show()

