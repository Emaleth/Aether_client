extends PanelContainer

onready var health_bar = $MarginContainer/HBoxContainer/VBoxContainer/Health
onready var mana_bar = $MarginContainer/HBoxContainer/VBoxContainer/Mana
onready var stamina_bar = $MarginContainer/HBoxContainer/VBoxContainer/Stamina

func _ready() -> void:
	health_bar.conf("gdsdf", 100, 34, Color(1, 0, 0, 1))
	mana_bar.conf("gdsdf", 100, 34, Color(0, 0, 1, 1))
	stamina_bar.conf("gdsdf", 100, 34, Color(1, 1, 0, 1))
