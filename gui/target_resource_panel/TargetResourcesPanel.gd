extends Control

onready var health_bar = $VBoxContainer/Health
onready var mana_bar = $VBoxContainer/Mana
onready var stamina_bar = $VBoxContainer/Stamina
onready var name_label = $VBoxContainer/Name

var current_enemy = null

func conf(target):
	if target == null:
		hide()
		if current_enemy != null:
			if current_enemy.is_connected("update_resources", self, "update_resources"):
				current_enemy.disconnect("update_resources", self, "update_resources")
				current_enemy.get_node("TargetIndicator").halt()
					
	else:
		if current_enemy != null and is_instance_valid(current_enemy):
			if current_enemy.is_connected("update_resources", self, "update_resources"):
				current_enemy.disconnect("update_resources", self, "update_resources")
			current_enemy.get_node("TargetIndicator").halt()
		if not target.is_connected("update_resources", self, "update_resources"):
			target.connect("update_resources", self, "update_resources")
			target.get_node("TargetIndicator").bounce()
		current_enemy = target
		name_label.text = target.statistics.name
		name_label.show()
		health_bar.conf(target.resources.health.maximum, target.resources.health.current, Color.red)
		mana_bar.conf(target.resources.mana.maximum, target.resources.mana.current, Color.blue)
		stamina_bar.conf(target.resources.stamina.maximum, target.resources.stamina.current, Color.orange)
		show()

func update_resources(res):
	health_bar.updt(res.health.current, res.health.maximum)
	mana_bar.updt(res.mana.current, res.mana.maximum)
	stamina_bar.updt(res.stamina.current, res.stamina.maximum)
