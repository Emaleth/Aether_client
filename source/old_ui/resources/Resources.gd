extends PanelContainer

onready var health_bar = $HBoxContainer/HealthBar
onready var mana_bar = $HBoxContainer/ManaBar


func _process(_delta: float) -> void:
	if GlobalVariables.resources_data.size() != 0:
		update_resources_bar(GlobalVariables.resources_data)
	
	
func update_resources_bar(_res):
	health_bar.update_ui(_res["h"]["c"], _res["h"]["m"])
	mana_bar.update_ui(_res["m"]["c"], _res["m"]["m"])

