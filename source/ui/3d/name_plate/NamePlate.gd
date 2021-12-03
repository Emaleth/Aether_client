extends Spatial

onready var name_label = $Viewport/VBoxContainer/NameLabel
onready var health_bar = $Viewport/VBoxContainer/HealthBar
onready var mana_bar = $Viewport/VBoxContainer/ManaBar
onready var sprite = $Sprite3D


func _ready() -> void:
	name_label.modulate.a = 0
	health_bar.modulate.a = 0
	mana_bar.modulate.a = 0
	health_bar.set_hud_font(name_label.get("custom_fonts/font"))
	mana_bar.set_hud_font(name_label.get("custom_fonts/font"))

	
func set_name_label(_name):
	name_label.text = _name
	name_label.modulate.a = 1
	
func update_health_bar(_hp, _max_hp):
	health_bar.update_ui(_hp, _max_hp)
	health_bar.modulate.a = 1
	
func update_mana_bar(_mana, _max_mana):
	mana_bar.update_ui(_mana, _max_mana)
	mana_bar.modulate.a = 1
