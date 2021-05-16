extends PanelContainer

onready var grid = $MarginContainer/GridContainer

onready var equipment : Dictionary = {
	"head" : {
		"slot" : grid.get_node("Head"),
		"empty_icon" : preload("res://textures/ui_head_ghost.png")
		},
	"hands" : {
		"slot" : grid.get_node("Hands"),
		"empty_icon" : preload("res://textures/ui_hands_ghost.png")
		},
	"feet" : {
		"slot" : grid.get_node("Feet"),
		"empty_icon" : preload("res://textures/ui_feet_ghost.png")
		},
	"upper_body" : {
		"slot" : grid.get_node("UpperBody"),
		"empty_icon" : preload("res://textures/ui_upper_body_ghost.png")
		},
	"lower_body" : {
		"slot" : grid.get_node("LowerBody"),
		"empty_icon" : preload("res://textures/ui_lower_body_ghost.png")
		},
	"cape" : {
		"slot" : grid.get_node("Cape"),
		"empty_icon" : preload("res://textures/ui_cape_ghost.png")
		},
	"belt" : {
		"slot" : grid.get_node("Belt"),
		"empty_icon" : preload("res://textures/ui_belt_ghost.png")
		},
	"shoulders" : {
		"slot" : grid.get_node("Shoulders"),
		"empty_icon" : preload("res://textures/ui_shoulders_ghost.png")
		},
	"necklace" : {
		"slot" : grid.get_node("Necklace"),
		"empty_icon" : preload("res://textures/ui_necklace_ghost.png")
		},
	"ammunition" : {
		"slot" : grid.get_node("Ammunition"),
		"empty_icon" : preload("res://textures/ui_ammunition_ghost.png")
		},
	"ranged_weapon" : {
		"slot" : grid.get_node("RangedWeapon"),
		"empty_icon" : preload("res://textures/ui_ranged_weapon_ghost.png")
		},
	"ring_1" : {
		"slot" : grid.get_node("Ring1"),
		"empty_icon" : preload("res://textures/ui_ring_ghost.png")
		},
	"ring_2" : {
		"slot" : grid.get_node("Ring2"),
		"empty_icon" : preload("res://textures/ui_ring_ghost.png")
		},
	"earring_1" : {
		"slot" : grid.get_node("Earring1"),
		"empty_icon" : preload("res://textures/ui_earring_ghost.png")
		},
	"earring_2" : {
		"slot" : grid.get_node("Earring2"),
		"empty_icon" : preload("res://textures/ui_earring_ghost.png")
		},
	"main_hand" : {
		"slot" : grid.get_node("MainHand"),
		"empty_icon" : preload("res://textures/ui_main_hand_ghost.png")
		},
	"off_hand" : {
		"slot" : grid.get_node("OffHand"),
		"empty_icon" : preload("res://textures/ui_off_hand_ghost.png")
		},
	"gathering_tools" : {
		"slot" : grid.get_node("GatheringTools"),
		"empty_icon" : preload("res://textures/ui_gathering_tools_ghost.png")
		},
	"amulet_1" : {
		"slot" : grid.get_node("Amulet1"),
		"empty_icon" : preload("res://textures/ui_amulet_ghost.png")
		},
	"amulet_2" : {
		"slot" : grid.get_node("Amulet2"),
		"empty_icon" : preload("res://textures/ui_amulet_ghost.png")
		},
	"amulet_3" : {
		"slot" : grid.get_node("Amulet3"),
		"empty_icon" : preload("res://textures/ui_amulet_ghost.png")
		},
	"back" : {
		"slot" : grid.get_node("Back"),
		"empty_icon" : preload("res://textures/ui_back_ghost.png")
		}
	}


func conf(actor):
	for i in actor.equipment:
		equipment.get(i).slot.conf(actor, i, "equipment", equipment.get(i).empty_icon)

func can_drop_data(position: Vector2, data) -> bool:
	return false
		
