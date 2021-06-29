extends Control

onready var login_account = $Login/VBoxContainer/AccountLine
onready var login_password = $Login/VBoxContainer/PasswordLine
onready var login_remember = $Login/VBoxContainer/HBoxContainer/CheckBox
onready var login_button = $Login/VBoxContainer/Login

onready var register_email = $Register/VBoxContainer/EmailLine
onready var register_password = $Login/VBoxContainer/PasswordLine
onready var register_password_repeat = $Register/VBoxContainer/PasswordRepeatLine
onready var register_agreement = $Register/VBoxContainer/HBoxContainer/CheckBox

	
func _on_AuthenticationScreen_tab_changed(tab: int) -> void:
	rect_size = get_child(tab).rect_size
	yield(get_tree(), "idle_frame")
	
func _on_Login_pressed() -> void:
	login()

func _on_Register_pressed() -> void:
	register()

func login():
	if login_account.text == "" or login_password.text == "":
		return
	else:
		login_button.disabled = true
		var username = login_account.get_text()
		var password = login_password.get_text()
		Gateway.connect_to_server(username, password)
	
func register():
	print("registering...")



