extends Control
# menu states
enum {LOGIN, REGISTER, LOADING}
# world scene
onready var game = preload("res://world/World.tscn")
# main tab container
onready var tab_container = $CenterContainer/AuthenticationScreen
# loading info / animation nodes
onready var loading_label = $MarginContainer/VBoxContainer/Label
onready var loading_bar = $MarginContainer/VBoxContainer/ProgressBar
# login window
onready var login_account = $CenterContainer/AuthenticationScreen/Login/VBoxContainer/AccountLine
onready var login_password = $CenterContainer/AuthenticationScreen/Login/VBoxContainer/PasswordLine
onready var login_remember = $CenterContainer/AuthenticationScreen/Login/VBoxContainer/HBoxContainer/CheckBox
onready var login_button = $CenterContainer/AuthenticationScreen/Login/VBoxContainer/Login
# register window
onready var register_email = $CenterContainer/AuthenticationScreen/Register/VBoxContainer/EmailLine
onready var register_password = $CenterContainer/AuthenticationScreen/Login/VBoxContainer/PasswordLine
onready var register_password_repeat = $CenterContainer/AuthenticationScreen/Register/VBoxContainer/PasswordRepeatLine
onready var register_agreement = $CenterContainer/AuthenticationScreen/Register/VBoxContainer/HBoxContainer/CheckBox
onready var register_button = $CenterContainer/AuthenticationScreen/Register/VBoxContainer/Register

onready var quit_button = $Quit


func _ready():
	Server.connect("sig_token_verification_success", self, "enter_world")
	Server.connect("sig_token_verification_failure", self, "set_menu_state", [LOGIN])
	login_button.self_modulate = Color.green
	register_button.self_modulate = Color.green
	quit_button.self_modulate = Color.red
	set_menu_state(LOGIN)
	
func set_menu_state(state):
	match state:
		LOGIN:
			tab_container.show()
			loading_bar.hide()
			loading_label.hide()
			login_button.disabled = false
			register_button.disabled = true
		REGISTER:
			tab_container.show()
			loading_bar.hide()
			loading_label.hide()
			login_button.disabled = true
			register_button.disabled = false
		LOADING:
			tab_container.hide()
			loading_bar.show()
			loading_label.show()
			login_button.disabled = true
			register_button.disabled = true
		
func enter_world():
	get_tree().change_scene_to(game)
	
func quit() -> void:
	get_tree().quit()

func tab_changed(tab):
	tab_container.rect_size = tab_container.get_child(tab).rect_size
	yield(get_tree(), "idle_frame")
	match tab:
		0:
			set_menu_state(LOGIN)
		1:
			set_menu_state(REGISTER)

func login() -> void:
	if login_account.text == "" or login_password.text == "":
		return
	else:
		login_button.disabled = true
		var username = login_account.get_text()
		var password = login_password.get_text()
		Gateway.connect_to_server(username, password, false)

func register() -> void:
	if register_email.text == "" or register_password.text == "" or register_password_repeat.text == "":
		return
	elif not register_agreement.pressed:
		return
	elif register_password.text.length() < 8:
		return
	elif not register_password.text == register_password_repeat.text:
		return
	else:
		register_button.disabled = true
		var username = register_email.get_text()
		var password = register_password.get_text()
		Gateway.connect_to_server(username, password, true)

