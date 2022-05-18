extends PanelContainer

onready var dashboard := $Dashboard
onready var hud := $HUD


func _ready() -> void:
	dashboard.hide()
	
	
func show_hud():
	hud.show()
	
	
func open_dashboard():
	dashboard.show()
		
