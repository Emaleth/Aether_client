extends PanelContainer

onready var health_bar = $VBoxContainer/HealthBar
onready var mana_bar = $VBoxContainer/ManaBar

func _process(_delta: float) -> void:
	if GlobalVariables.resources_data.size() != 0:
		update_resources_bar(GlobalVariables.resources_data)
	
func update_resources_bar(_res):
	health_bar.update_ui(_res["health"]["current"], _res["health"]["max"])
	mana_bar.update_ui(_res["mana"]["current"], _res["mana"]["max"])
