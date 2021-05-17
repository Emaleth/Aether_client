extends PanelContainer

onready var grid = $MarginContainer/GridContainer

onready var equipment : Dictionary = {
	"head" : {
		"slot" : grid.get_node("Head"),
		"empty_icon" : preload("res://textures/icons/grey/helmet.png")
		},
	"hands" : {
		"slot" : grid.get_node("Hands"),
		"empty_icon" : preload("res://textures/icons/grey/gauntlet.png")
		},
	"feet" : {
		"slot" : grid.get_node("Feet"),
		"empty_icon" : preload("res://textures/icons/grey/boots.png")
		},
	"upper_body" : {
		"slot" : grid.get_node("UpperBody"),
		"empty_icon" : preload("res://textures/icons/grey/armor.png")
		},
	"lower_body" : {
		"slot" : grid.get_node("LowerBody"),
		"empty_icon" : preload("res://textures/icons/grey/breeches.png")
		},
	"cape" : {
		"slot" : grid.get_node("Cape"),
		"empty_icon" : preload("res://textures/icons/grey/cape.png")
		},
	"belt" : {
		"slot" : grid.get_node("Belt"),
		"empty_icon" : preload("res://textures/icons/grey/belt.png")
		},
	"shoulders" : {
		"slot" : grid.get_node("Shoulders"),
		"empty_icon" : preload("res://textures/icons/grey/shoulders.png")
		},
	"necklace" : {
		"slot" : grid.get_node("Necklace"),
		"empty_icon" : preload("res://textures/icons/grey/necklace.png")
		},
	"ammunition" : {
		"slot" : grid.get_node("Ammunition"),
		"empty_icon" : preload("res://textures/icons/grey/arrows.png")
		},
	"ranged_weapon" : {
		"slot" : grid.get_node("RangedWeapon"),
		"empty_icon" : preload("res://textures/icons/grey/crossbow.png")
		},
	"ring_1" : {
		"slot" : grid.get_node("Ring1"),
		"empty_icon" : preload("res://textures/icons/grey/ring.png")
		},
	"ring_2" : {
		"slot" : grid.get_node("Ring2"),
		"empty_icon" : preload("res://textures/icons/grey/ring.png")
		},
	"earring_1" : {
		"slot" : grid.get_node("Earring1"),
		"empty_icon" : preload("res://textures/icons/grey/earrings.png")
		},
	"earring_2" : {
		"slot" : grid.get_node("Earring2"),
		"empty_icon" : preload("res://textures/icons/grey/earrings.png")
		},
	"main_hand" : {
		"slot" : grid.get_node("MainHand"),
		"empty_icon" : preload("res://textures/icons/grey/sword.png")
		},
	"off_hand" : {
		"slot" : grid.get_node("OffHand"),
		"empty_icon" : preload("res://textures/icons/grey/shield.png")
		},
	"gathering_tools" : {
		"slot" : grid.get_node("GatheringTools"),
		"empty_icon" : preload("res://textures/icons/grey/tools.png")
		},
	"amulet_1" : {
		"slot" : grid.get_node("Amulet1"),
		"empty_icon" : preload("res://textures/icons/grey/amulet.png")
		},
	"amulet_2" : {
		"slot" : grid.get_node("Amulet2"),
		"empty_icon" : preload("res://textures/icons/grey/amulet.png")
		},
	"amulet_3" : {
		"slot" : grid.get_node("Amulet3"),
		"empty_icon" : preload("res://textures/icons/grey/amulet.png")
		},
	"back" : {
		"slot" : grid.get_node("Back"),
		"empty_icon" : preload("res://textures/icons/grey/wing.png")
		}
	}


func conf(actor):
	for i in actor.equipment:
		equipment.get(i).slot.conf(actor, i, "equipment", equipment.get(i).empty_icon)

		
