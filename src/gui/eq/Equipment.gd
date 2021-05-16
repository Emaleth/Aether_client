extends PanelContainer

onready var grid = $MarginContainer/GridContainer

onready var equipment : Dictionary = {
	"head" : {
		"slot" : grid.get_node("Head"),
		"empty_icon" : preload("res://textures/icons/black/helmet_50%.png")
		},
	"hands" : {
		"slot" : grid.get_node("Hands"),
		"empty_icon" : preload("res://textures/icons/black/gauntlet_50%.png")
		},
	"feet" : {
		"slot" : grid.get_node("Feet"),
		"empty_icon" : preload("res://textures/icons/black/boots_50%.png")
		},
	"upper_body" : {
		"slot" : grid.get_node("UpperBody"),
		"empty_icon" : preload("res://textures/icons/black/armor_50%.png")
		},
	"lower_body" : {
		"slot" : grid.get_node("LowerBody"),
		"empty_icon" : preload("res://textures/icons/black/breeches_50%.png")
		},
	"cape" : {
		"slot" : grid.get_node("Cape"),
		"empty_icon" : preload("res://textures/icons/black/cape_50%.png")
		},
	"belt" : {
		"slot" : grid.get_node("Belt"),
		"empty_icon" : preload("res://textures/icons/black/belt_50%.png")
		},
	"shoulders" : {
		"slot" : grid.get_node("Shoulders"),
		"empty_icon" : preload("res://textures/icons/black/shoulders_50%.png")
		},
	"necklace" : {
		"slot" : grid.get_node("Necklace"),
		"empty_icon" : preload("res://textures/icons/black/necklace_50%.png")
		},
	"ammunition" : {
		"slot" : grid.get_node("Ammunition"),
		"empty_icon" : preload("res://textures/icons/black/arrows_50%.png")
		},
	"ranged_weapon" : {
		"slot" : grid.get_node("RangedWeapon"),
		"empty_icon" : preload("res://textures/icons/black/crossbow_50%.png")
		},
	"ring_1" : {
		"slot" : grid.get_node("Ring1"),
		"empty_icon" : preload("res://textures/icons/black/ring_50%.png")
		},
	"ring_2" : {
		"slot" : grid.get_node("Ring2"),
		"empty_icon" : preload("res://textures/icons/black/ring_50%.png")
		},
	"earring_1" : {
		"slot" : grid.get_node("Earring1"),
		"empty_icon" : preload("res://textures/icons/black/earrings_50%.png")
		},
	"earring_2" : {
		"slot" : grid.get_node("Earring2"),
		"empty_icon" : preload("res://textures/icons/black/earrings_50%.png")
		},
	"main_hand" : {
		"slot" : grid.get_node("MainHand"),
		"empty_icon" : preload("res://textures/icons/black/sword_50%.png")
		},
	"off_hand" : {
		"slot" : grid.get_node("OffHand"),
		"empty_icon" : preload("res://textures/icons/black/shield_50%.png")
		},
	"gathering_tools" : {
		"slot" : grid.get_node("GatheringTools"),
		"empty_icon" : preload("res://textures/icons/black/tools_50%.png")
		},
	"amulet_1" : {
		"slot" : grid.get_node("Amulet1"),
		"empty_icon" : preload("res://textures/icons/black/amulet_50%.png")
		},
	"amulet_2" : {
		"slot" : grid.get_node("Amulet2"),
		"empty_icon" : preload("res://textures/icons/black/amulet_50%.png")
		},
	"amulet_3" : {
		"slot" : grid.get_node("Amulet3"),
		"empty_icon" : preload("res://textures/icons/black/amulet_50%.png")
		},
	"back" : {
		"slot" : grid.get_node("Back"),
		"empty_icon" : preload("res://textures/icons/black/wing_50%.png")
		}
	}


func conf(actor):
	for i in actor.equipment:
		equipment.get(i).slot.conf(actor, i, "equipment", equipment.get(i).empty_icon)

func can_drop_data(position: Vector2, data) -> bool:
	return false
		
