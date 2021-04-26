extends Spatial

onready var name_label = $Quat/Viewport/vbox/Name
onready var health_bar = $Quat/Viewport/vbox/Heatlh
onready var mana_bar = $Quat/Viewport/vbox/Mana
onready var stamina_bar = $Quat/Viewport/vbox/Stamina


func _ready() -> void:
	$Quat.get("material/0").albedo_texture = $Quat/Viewport.get_texture()

func conf(name, resources) -> void:
	name_label.text = name
	
	health_bar.conf(tr("00006"), resources.health.maximum, resources.health.current, Color(1, 0, 0, 1))
	mana_bar.conf(tr("00008"), resources.mana.maximum, resources.mana.current, Color(0, 0, 1, 1))
	stamina_bar.conf(tr("00010"), resources.stamina.maximum, resources.stamina.current, Color(1, 1, 0, 1))
	
	health_bar.get_node("Label").hide()
	mana_bar.get_node("Label").hide()
	stamina_bar.get_node("Label").hide()
