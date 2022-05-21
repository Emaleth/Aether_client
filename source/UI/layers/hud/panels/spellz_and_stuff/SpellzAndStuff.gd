extends PanelContainer


onready var health_bar_container : HBoxContainer = $VBoxContainer/HealthBar
onready var mana_bar_container : HBoxContainer = $VBoxContainer/VBoxContainer/VBoxContainer/ManaBar
onready var stamina_bar_container : HBoxContainer = $VBoxContainer/VBoxContainer/VBoxContainer/StaminaBar
onready var casting_bar_container : HBoxContainer = $VBoxContainer/HBoxContainer/CastingBar


func _ready() -> void:
	casting_bar_container.hide()
	

func set_health_bar(_current_value : float, _max_value : float):
	health_bar_container.get_node("ProgressBar").value = _current_value
	health_bar_container.get_node("ProgressBar").max_value = _max_value
	
	
func set_mana_bar(_current_value : float, _max_value : float):
	mana_bar_container.get_node("ProgressBar").value = _current_value
	mana_bar_container.get_node("ProgressBar").max_value = _max_value
	
	
func set_stamina_bar(_current_value : float, _max_value : float):
	stamina_bar_container.get_node("ProgressBar").value = _current_value
	stamina_bar_container.get_node("ProgressBar").max_value = _max_value


func set_action_bar(_data : Dictionary):
	pass
