extends PanelContainer


onready var register_email = $VBoxContainer/EmailLine
onready var register_password = $VBoxContainer/PasswordLine
onready var register_password_repeat = $VBoxContainer/PasswordRepeatLine
onready var register_agreement = $VBoxContainer/HBoxContainer/CheckBox
onready var register_button = $VBoxContainer/Register


signal switch_to_login


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


func _on_Register_pressed() -> void:
	AudioHandler.play_sfx("button")
	register()


func _on_LoginTab_pressed() -> void:
	AudioHandler.play_sfx("button")
	emit_signal("switch_to_login")
