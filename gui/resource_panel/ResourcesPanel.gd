extends Control

onready var health_bar = $VBoxContainer/Health
onready var mana_bar = $VBoxContainer/HBoxContainer/Mana
onready var stamina_bar = $VBoxContainer/HBoxContainer/Stamina

var configured = false

func conf(resources):
	if configured == false:
		health_bar.conf(resources.health.maximum, resources.health.current, Color.red)
		mana_bar.conf(resources.mana.maximum, resources.mana.current, Color.blue)
		stamina_bar.conf(resources.stamina.maximum, resources.stamina.current, Color.orange)
		configured = true
	else:
		health_bar.updt(resources.health.current, resources.health.maximum)
		mana_bar.updt(resources.mana.current, resources.mana.maximum)
		stamina_bar.updt(resources.stamina.current, resources.stamina.maximum)

