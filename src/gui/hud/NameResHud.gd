extends Spatial

onready var name_label = $Quat/Viewport/vbox/HBoxContainer/Name
onready var level_label = $Quat/Viewport/vbox/HBoxContainer/Lvl
onready var guild_label = $Quat/Viewport/vbox/Guild
onready var title_lable = $Quat/Viewport/vbox/Title
onready var class_label = $Quat/Viewport/vbox/HBoxContainer/Class
onready var health_bar = $Quat/Viewport/vbox/MarginContainer/VBoxContainer/Heatlh
onready var mana_bar = $Quat/Viewport/vbox/MarginContainer/VBoxContainer/Mana
onready var stamina_bar = $Quat/Viewport/vbox/MarginContainer/VBoxContainer/Stamina


func _ready() -> void:
	$Quat.get("material/0").albedo_texture = $Quat/Viewport.get_texture()

func conf(stats = {}, res = {}) -> void:
	if stats.name != "":
		name_label.text = stats.name
	else:
		name_label.hide()

	if stats.title != "":
		title_lable.text = stats.title
	else:
		title_lable.hide()

	if stats.guild != "":
		guild_label.text = stats.guild
	else:
		guild_label.hide()
	
	if stats.level != "":
		level_label.text = stats.level
	else:
		level_label.hide()

	if res.health.maximum > 0:
		health_bar.conf(tr("00006"), res.health.maximum, res.health.current, Color(1, 0, 0, 1))
	else:
		health_bar.hide()

	if res.mana.maximum > 0:
		mana_bar.conf(tr("00008"), res.mana.maximum, res.mana.current, Color(0, 0, 1, 1))
	else:
		mana_bar.hide()

	if res.stamina.maximum > 0:
		stamina_bar.conf(tr("00010"), res.stamina.maximum, res.stamina.current, Color(1, 1, 0, 1))
	else:
		stamina_bar.hide()
		
		
	health_bar.get_node("ProgressBar").percent_visible = false
	mana_bar.get_node("ProgressBar").percent_visible = false
	stamina_bar.get_node("ProgressBar").percent_visible = false
		
	mana_bar.get_node("Label").hide()
	stamina_bar.get_node("Label").hide()
	health_bar.get_node("Label").hide()
