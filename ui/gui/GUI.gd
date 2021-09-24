extends CanvasLayer

enum {NORMAL, MANAGMENT, SETTINGS}
onready var normal_panel = $Normal 
onready var managment_panel = $Managment 
onready var settings_panel = $Settings
# clock
onready var clock_label = $Normal/Info/ServerClock/Clock
onready var latency_label = $Normal/Info/Latency/label
# resource bars
onready var health_bar = $Normal/ResourceBars/HealthBar
onready var mana_bar = $Normal/ResourceBars/ManaBar
# chat
onready var chat_box = $Normal/ChatBox
onready var msg_list = $Normal/ChatBox/VBoxContainer/PanelContainer/MsgList
onready var template_chat_line = $Normal/ChatBox/VBoxContainer/PanelContainer/MsgList/Template
onready var input_line = $Normal/ChatBox/VBoxContainer/LineEdit
# minimap
onready var minimap = $Normal/Minimap
onready var menu = load("res://ui/menu/Menu.tscn")

onready var aim_hint = $Normal/CrosshairContainer/MarginContainer/Label

var chat = false
var mode

onready var audio_bus_master_slider = $Settings/PanelContainer/HBoxContainer/Value/MasterVolSlide
onready var audio_bus_bgm_slider = $Settings/PanelContainer/HBoxContainer/Value/MusicVolSlide
onready var audio_bus_ui_slider = $Settings/PanelContainer/HBoxContainer/Value/UISFXVolSlide
onready var audio_bus_env_slider = $Settings/PanelContainer/HBoxContainer/Value/EnvVolSlide
onready var audio_bus_sfx_slider = $Settings/PanelContainer/HBoxContainer/Value/SFXVolSlide

func _ready() -> void:
	Server.connect("s_update_chat_state", self, "update_chat_box")
	template_chat_line.hide()
	set_gui_mode(NORMAL)
	get_audio_slider_values()
	
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
		
	clock_label.text = "Server Time: %s:%s:%s" % [hour, minute, second]
	
func format_chat_timestamp():
	var date_dict = OS.get_datetime_from_unix_time(Server.client_clock / 1000)
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
		
func set_gui_mode(_mode):
	mode = _mode
	match _mode:
		NORMAL:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			normal_panel.show()
			managment_panel.hide()
			settings_panel.hide()
		MANAGMENT:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			normal_panel.hide()
			managment_panel.show()
			settings_panel.hide()
		SETTINGS:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			normal_panel.hide()
			managment_panel.hide()
			settings_panel.show()
			
func _unhandled_key_input(event: InputEventKey) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if mode == NORMAL:
			if not input_line.has_focus():
				chat = true
				input_line.grab_focus()
	if Input.is_action_just_pressed("ui_mode"):
		set_gui_mode(MANAGMENT)
	if Input.is_action_just_pressed("ui_cancel"):
		if mode == NORMAL:
			set_gui_mode(SETTINGS)
		else:
			set_gui_mode(NORMAL)
			
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
		new_line.get_node("Timestamp").text = format_chat_timestamp()
		new_line.get_node("Sender").text = "%s: " % str(sender)
		new_line.get_node("Message").text = str(message)
		msg_list.add_child(new_line)
		new_line.show()

func _on_LineEdit_text_entered(new_text: String) -> void:
	Server.send_chat_msg(new_text)
	input_line.clear()
	input_line.release_focus()
	chat = false

func _on_SettingsButton_pressed() -> void:
	set_gui_mode(SETTINGS)

func _on_NormalButton_pressed() -> void:
	set_gui_mode(NORMAL)

func _on_QuitButton_pressed() -> void:
	get_tree().change_scene_to(menu)

func get_audio_slider_values():
	audio_bus_master_slider.value = db2linear(AudioServer.get_bus_volume_db(0))
	audio_bus_env_slider.value = db2linear(AudioServer.get_bus_volume_db(1))
	audio_bus_bgm_slider.value = db2linear(AudioServer.get_bus_volume_db(2))
	audio_bus_sfx_slider.value = db2linear(AudioServer.get_bus_volume_db(3))
	audio_bus_ui_slider.value = db2linear(AudioServer.get_bus_volume_db(4))
	
func _on_MasterVolSlide_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear2db(value))

func _on_MusicVolSlide_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear2db(value))

func _on_SFXVolSlide_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(3, linear2db(value))

func _on_EnvVolSlide_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear2db(value))

func _on_UISFXVolSlide_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(4, linear2db(value))

func _on_mast_toggled(button_pressed: bool) -> void:
	AudioServer.set_bus_mute(0, button_pressed)

func _on_mus_toggled(button_pressed: bool) -> void:
	AudioServer.set_bus_mute(2, button_pressed)

func _on_sfx_toggled(button_pressed: bool) -> void:
	AudioServer.set_bus_mute(3, button_pressed)

func _on_ui_toggled(button_pressed: bool) -> void:
	AudioServer.set_bus_mute(4, button_pressed)
	
func _on_env_toggled(button_pressed: bool) -> void:
	AudioServer.set_bus_mute(1, button_pressed)
	
