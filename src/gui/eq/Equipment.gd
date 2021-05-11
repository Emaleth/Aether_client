extends WindowDialog

onready var equipment : Dictionary = {
	"head" : {
		"slot" : $MarginContainer/GridContainer/Head,
		"empty_icon" : preload("res://textures/head_ghost.png")
		},
	"hands" : {
		"slot" : $MarginContainer/GridContainer/Hands,
		"empty_icon" : preload("res://textures/hands_ghost.png")
		},
	"feet" : {
		"slot" : $MarginContainer/GridContainer/Feet,
		"empty_icon" : preload("res://textures/feet_ghost.png")
		},
	"upper_body" : {
		"slot" : $MarginContainer/GridContainer/UpperBody,
		"empty_icon" : preload("res://textures/upper_body_ghost.png")
		},
	"lower_body" : {
		"slot" : $MarginContainer/GridContainer/LowerBody,
		"empty_icon" : preload("res://textures/lower_body_ghost.png")
		},
	"cape" : {
		"slot" : $MarginContainer/GridContainer/Cape,
		"empty_icon" : preload("res://textures/cape_ghost.png")
		},
	"belt" : {
		"slot" : $MarginContainer/GridContainer/Belt,
		"empty_icon" : preload("res://textures/belt_ghost.png")
		},
	"shoulders" : {
		"slot" : $MarginContainer/GridContainer/Shoulders,
		"empty_icon" : preload("res://textures/shoulders_ghost.png")
		},
	"necklace" : {
		"slot" : $MarginContainer/GridContainer/Necklace,
		"empty_icon" : preload("res://textures/necklace_ghost.png")
		},
	"ammunition" : {
		"slot" : $MarginContainer/GridContainer/Ammunition,
		"empty_icon" : preload("res://textures/ammunition_ghost.png")
		},
	"ranged_weapon" : {
		"slot" : $MarginContainer/GridContainer/RangedWeapon,
		"empty_icon" : preload("res://textures/ranged_weapon_ghost.png")
		},
	"ring_1" : {
		"slot" : $MarginContainer/GridContainer/Ring1,
		"empty_icon" : preload("res://textures/ring_ghost.png")
		},
	"ring_2" : {
		"slot" : $MarginContainer/GridContainer/Ring2,
		"empty_icon" : preload("res://textures/ring_ghost.png")
		},
	"earring_1" : {
		"slot" : $MarginContainer/GridContainer/Earring1,
		"empty_icon" : preload("res://textures/earring_ghost.png")
		},
	"earring_2" : {
		"slot" : $MarginContainer/GridContainer/Earring2,
		"empty_icon" : preload("res://textures/earring_ghost.png")
		},
	"main_hand" : {
		"slot" : $MarginContainer/GridContainer/MainHand,
		"empty_icon" : preload("res://textures/main_hand_ghost.png")
		},
	"off_hand" : {
		"slot" : $MarginContainer/GridContainer/OffHand,
		"empty_icon" : preload("res://textures/off_hand_ghost.png")
		},
	"gathering_tools" : {
		"slot" : $MarginContainer/GridContainer/GatheringTools,
		"empty_icon" : preload("res://textures/gathering_tools_ghost.png")
		},
	"amulet_1" : {
		"slot" : $MarginContainer/GridContainer/Amulet1,
		"empty_icon" : preload("res://textures/amulet_ghost.png")
		},
	"amulet_2" : {
		"slot" : $MarginContainer/GridContainer/Amulet2,
		"empty_icon" : preload("res://textures/amulet_ghost.png")
		},
	"amulet_3" : {
		"slot" : $MarginContainer/GridContainer/Amulet3,
		"empty_icon" : preload("res://textures/amulet_ghost.png")
		},
	"back" : {
		"slot" : $MarginContainer/GridContainer/Back,
		"empty_icon" : preload("res://textures/back_ghost.png")
		}
	}

func _ready() -> void:
	window_title = tr("00013")

func _on_MarginContainer_sort_children() -> void:
	rect_min_size = $MarginContainer.rect_min_size
	rect_size = $MarginContainer.rect_size

func conf(actor):
	for i in actor.equipment:
		equipment.get(i).slot.conf(actor, i, "equipment", equipment.get(i).empty_icon)

func can_drop_data(position: Vector2, data) -> bool:
	return false
		


