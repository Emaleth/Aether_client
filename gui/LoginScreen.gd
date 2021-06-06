extends Control

onready var login_panel = $PanelContainer/VBoxContainer/Login
onready var login_account = $PanelContainer/VBoxContainer/Login/AccountLine
onready var login_password = $PanelContainer/VBoxContainer/Login/PasswordLine
onready var login_remember = $PanelContainer/VBoxContainer/Login/HBoxContainer/CheckBox

onready var register_panel = $PanelContainer/VBoxContainer/Register
onready var register_email = $PanelContainer/VBoxContainer/Register/EmailLine
onready var register_password = $PanelContainer/VBoxContainer/Login/PasswordLine
onready var register_password_repeat = $PanelContainer/VBoxContainer/Register/PasswordRepeatLine
onready var register_agreement = $PanelContainer/VBoxContainer/Register/HBoxContainer/CheckBox


func _ready() -> void:
	login_panel.show()
	register_panel.hide()
	
func _on_VBoxContainer_sort_children() -> void:
	$PanelContainer.rect_size = $PanelContainer/VBoxContainer.rect_size
	$PanelContainer.rect_position = rect_size / 2 - $PanelContainer.rect_size / 2
	yield(get_tree(), "idle_frame")
	
func _on_Login_pressed() -> void:
	if login_panel.visible:
		login()
	else:
		login_panel.show()
		register_panel.hide()

func _on_Register_pressed() -> void:
	if register_panel.visible:
		register()
	else:
		register_panel.show()
		login_panel.hide()

func login():
	pass
	
func register():
	pass
