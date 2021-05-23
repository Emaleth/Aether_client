extends PanelContainer

onready var grid = $MarginContainer/HBoxContainer/GridContainer
onready var stat_container = $MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer
onready var points_label = $MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer/PointsLabel

onready var equipment : Dictionary = {
	"head" : {
		"slot" : grid.get_node("Head"),
		"empty_icon" : preload("res://textures/icons/helmet.png")
		},
	"hands" : {
		"slot" : grid.get_node("Hands"),
		"empty_icon" : preload("res://textures/icons/gauntlet.png")
		},
	"feet" : {
		"slot" : grid.get_node("Feet"),
		"empty_icon" : preload("res://textures/icons/boots.png")
		},
	"upper_body" : {
		"slot" : grid.get_node("UpperBody"),
		"empty_icon" : preload("res://textures/icons/armor.png")
		},
	"lower_body" : {
		"slot" : grid.get_node("LowerBody"),
		"empty_icon" : preload("res://textures/icons/breeches.png")
		},
	"cape" : {
		"slot" : grid.get_node("Cape"),
		"empty_icon" : preload("res://textures/icons/cape.png")
		},
	"belt" : {
		"slot" : grid.get_node("Belt"),
		"empty_icon" : preload("res://textures/icons/belt.png")
		},
	"shoulders" : {
		"slot" : grid.get_node("Shoulders"),
		"empty_icon" : preload("res://textures/icons/shoulders.png")
		},
	"necklace" : {
		"slot" : grid.get_node("Necklace"),
		"empty_icon" : preload("res://textures/icons/necklace.png")
		},
	"ammunition" : {
		"slot" : grid.get_node("Ammunition"),
		"empty_icon" : preload("res://textures/icons/arrows.png")
		},
	"ranged_weapon" : {
		"slot" : grid.get_node("RangedWeapon"),
		"empty_icon" : preload("res://textures/icons/crossbow.png")
		},
	"ring_1" : {
		"slot" : grid.get_node("Ring1"),
		"empty_icon" : preload("res://textures/icons/ring.png")
		},
	"ring_2" : {
		"slot" : grid.get_node("Ring2"),
		"empty_icon" : preload("res://textures/icons/ring.png")
		},
	"earring_1" : {
		"slot" : grid.get_node("Earring1"),
		"empty_icon" : preload("res://textures/icons/earrings.png")
		},
	"earring_2" : {
		"slot" : grid.get_node("Earring2"),
		"empty_icon" : preload("res://textures/icons/earrings.png")
		},
	"main_hand" : {
		"slot" : grid.get_node("MainHand"),
		"empty_icon" : preload("res://textures/icons/sword.png")
		},
	"off_hand" : {
		"slot" : grid.get_node("OffHand"),
		"empty_icon" : preload("res://textures/icons/shield.png")
		},
	"gathering_tools" : {
		"slot" : grid.get_node("GatheringTools"),
		"empty_icon" : preload("res://textures/icons/tool.png")
		},
	"amulet_1" : {
		"slot" : grid.get_node("Amulet1"),
		"empty_icon" : preload("res://textures/icons/amulet.png")
		},
	"amulet_2" : {
		"slot" : grid.get_node("Amulet2"),
		"empty_icon" : preload("res://textures/icons/amulet.png")
		},
	"amulet_3" : {
		"slot" : grid.get_node("Amulet3"),
		"empty_icon" : preload("res://textures/icons/amulet.png")
		},
	"back" : {
		"slot" : grid.get_node("Back"),
		"empty_icon" : preload("res://textures/icons/wing.png")
		}
	}
	
onready var stats = {
	"strenght" : {
		"name" : stat_container.get_node("Strenght/Label"),
		"number" : stat_container.get_node("Strenght/Q"),
		"button" : stat_container.get_node("Strenght/Add")
	},
	"dexterity" : {
		"name" : stat_container.get_node("Dexterity/Label"),
		"number" : stat_container.get_node("Dexterity/Q"),
		"button" : stat_container.get_node("Dexterity/Add")
	},
	"constitution" : {
		"name" : stat_container.get_node("Constitution/Label"),
		"number" : stat_container.get_node("Constitution/Q"),
		"button" : stat_container.get_node("Constitution/Add")
	},
	"intelligence" : {
		"name" : stat_container.get_node("Intelligence/Label"),
		"number" : stat_container.get_node("Intelligence/Q"),
		"button" : stat_container.get_node("Intelligence/Add")
	},
	"wisdom" : {
		"name" : stat_container.get_node("Wisdom/Label"),
		"number" : stat_container.get_node("Wisdom/Q"),
		"button" : stat_container.get_node("Wisdom/Add")
	}
}

func conf(actor, quantity_panel):
	for i in actor.equipment:
		equipment.get(i).slot.conf(actor, i, "equipment", quantity_panel, equipment.get(i).empty_icon)

	for i in stats:
		if not stats.get(i).button.is_connected("pressed", actor, "increase_stat"):
			stats.get(i).name.text = str(i).capitalize()
			stats.get(i).number.rect_min_size = stats.get(i).number.rect_size
			stat_container.rect_min_size = stat_container.rect_size
			update_stats(actor.s, actor.free_points)
			stats.get(i).button.connect("pressed", actor, "increase_stat", [i])
			stats.get(i).button.get_child(0).self_modulate = Global.toggle_off
	if not actor.is_connected("update_stats", self, "update_stats"):
		actor.connect("update_stats", self, "update_stats")
		
func update_stats(s, points):
	for i in stats:
		stats.get(i).number.text = str(s.get(i))
	if points > 0:
		for i in stats:
			stats.get(i).button.show()
			stats.get(i).button.disabled = false
		points_label.text = "Remaining points: %s" % points
	else:
		for i in stats:
			stats.get(i).button.hide()
			stats.get(i).button.disabled = true
		points_label.text = ""
		
