extends Control

onready var health_bar = $VBoxContainer/Health
onready var mana_bar = $VBoxContainer/HBoxContainer/Mana
onready var stamina_bar = $VBoxContainer/HBoxContainer/Stamina


func conf(resources):
	health_bar.conf(resources.health.maximum, resources.health.current, Color.red)
	mana_bar.conf(resources.mana.maximum, resources.mana.current, Color.blue)
	stamina_bar.conf(resources.stamina.maximum, resources.stamina.current, Color.orange)


func update_resources(res):
	health_bar.updt(res.health.current, res.health.maximum)
	mana_bar.updt(res.mana.current, res.mana.maximum)
	stamina_bar.updt(res.stamina.current, res.stamina.maximum)
