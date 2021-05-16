extends HBoxContainer

var showing_all = true
var xxx

onready var weapon_toggle = $WeaponToggle
onready var armor_toggle = $ArmorToggle
onready var jewelry_toggle = $JewelryToggle
onready var ammunition_toggle = $AmmunitionToggle
onready var tool_toggle = $ToolToggle
onready var rune_toggle = $RuneToggle
onready var potion_toggle = $PotionToggle


func show_all_slots():
	showing_all = true
	
	weapon_toggle.pressed = true
	armor_toggle.pressed = true
	jewelry_toggle.pressed = true
	ammunition_toggle.pressed = true
	tool_toggle.pressed = true
	rune_toggle.pressed = true
	potion_toggle.pressed = true
	xxx.show_slots(["weapon", "armor", "jewelry", "ammunition", "tool", "rune", "potion", "amulet"])
	
func hide_all_slots():
	showing_all = false
	
	weapon_toggle.pressed = false
	armor_toggle.pressed = false
	jewelry_toggle.pressed = false
	ammunition_toggle.pressed = false
	tool_toggle.pressed = false
	rune_toggle.pressed = false
	potion_toggle.pressed = false
	xxx.hide_slots(["weapon", "armor", "jewelry", "ammunition", "tool", "rune", "potion", "amulet"])
	
func _on_ShowAll_pressed() -> void:
	if showing_all == true:
		hide_all_slots()
	else:
		show_all_slots()
