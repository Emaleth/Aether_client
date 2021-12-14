extends Control
# menu states
enum {LOGIN, REGISTER, LOADING}
# world scene
onready var game = preload("res://source/world/World.tscn")
# main tab container
#onready var tab_container = $CenterContainer/AuthenticationScreen
onready var login_panel = $CenterContainer/LoginPanel
onready var register_panel = $CenterContainer/RegisterPanel
# loading info / animation nodes

onready var quit_button = $Quit


func _ready():
	Server.connect("s_token_verification_success", self, "enter_world")
	Server.connect("s_token_verification_failure", self, "set_menu_state", [LOGIN])
	login_panel.connect("switch_to_loading", self, "set_menu_state", [LOADING])
	login_panel.connect("switch_to_register", self, "set_menu_state", [REGISTER])
	register_panel.connect("switch_to_login", self, "set_menu_state", [LOGIN])
	set_menu_state(LOGIN)
	
	
func set_menu_state(state):
	match state:
		LOGIN:
			login_panel.show()
			register_panel.hide()
			login_panel.login_button.disabled = false
			register_panel.register_button.disabled = true
		REGISTER:
			login_panel.hide()
			register_panel.show()
			login_panel.login_button.disabled = true
			register_panel.register_button.disabled = false
		LOADING:
			login_panel.hide()
			register_panel.hide()
			login_panel.login_button.disabled = true
			register_panel.register_button.disabled = true

		
func enter_world():
	get_tree().change_scene_to(game)

	
func quit() -> void:
	get_tree().quit()

