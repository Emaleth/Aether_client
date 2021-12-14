extends PanelContainer


onready var login_account = $VBoxContainer/AccountLine
onready var login_password = $VBoxContainer/PasswordLine
onready var login_remember = $VBoxContainer/HBoxContainer/CheckBox
onready var login_button = $VBoxContainer/Login

signal switch_to_register
signal switch_to_loading

func login() -> void:
	if login_account.text == "" or login_password.text == "":
		return
	else:
		emit_signal("switch_to_loading")
		login_button.disabled = true
		var username = login_account.get_text()
		var password = login_password.get_text()
		Gateway.connect_to_server(username, password, false)
		

func _on_RegisterTab_pressed() -> void:
	emit_signal("switch_to_register")


func _on_Login_pressed() -> void:
	login()
