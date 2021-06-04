extends PanelContainer

onready var grid = $MarginContainer/HBoxContainer/GridContainer
onready var stat_container = $MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer
onready var points_label = $MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer/PointsLabel

onready var equipment : Dictionary = {
	"head" :  grid.get_node("Head"),
	"hands" : grid.get_node("Hands"),
	"feet" : grid.get_node("Feet"),
	"upper_body" : grid.get_node("UpperBody"),
	"lower_body" : grid.get_node("LowerBody"),
	"cape" : grid.get_node("Cape"),
	"belt" : grid.get_node("Belt"),
	"shoulders" : grid.get_node("Shoulders"),
	"necklace" : grid.get_node("Necklace"),
	"ammunition" : grid.get_node("Ammunition"),
	"ranged_weapon" : grid.get_node("RangedWeapon"),
	"ring_1" : grid.get_node("Ring1"),
	"ring_2" : grid.get_node("Ring2"),
	"earring_1" : grid.get_node("Earring1"),
	"earring_2" : grid.get_node("Earring2"),
	"main_hand" : grid.get_node("MainHand"),
	"off_hand" : grid.get_node("OffHand"),
	"gathering_tools" : grid.get_node("GatheringTools"),
	"amulet_1" : grid.get_node("Amulet1"),
	"amulet_2" : grid.get_node("Amulet2"),
	"amulet_3" : grid.get_node("Amulet3"),
	"back" : grid.get_node("Back")
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
	},
	"charisma" : {
		"name" : stat_container.get_node("Charisma/Label"),
		"number" : stat_container.get_node("Charisma/Q"),
		"button" : stat_container.get_node("Charisma/Add")
	}
}

func _ready() -> void:
	$Close/TextureRect.self_modulate = Global.close_button
	
func conf(actor, quantity_panel):
	for i in actor.equipment:
		equipment.get(i).conf(actor, i, "equipment", quantity_panel)

	for i in stats:
		if not stats.get(i).button.is_connected("pressed", actor, "increase_stat"):
			stats.get(i).name.text = str(i).capitalize()
			stats.get(i).number.rect_min_size = stats.get(i).number.rect_size
			stat_container.rect_min_size = stat_container.rect_size
			update_stats(actor.attributes.total, actor.attributes.points)
			stats.get(i).button.connect("pressed", actor, "increase_stat", [i])
			stats.get(i).button.get_child(0).self_modulate = Global.button_normal
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
		
func _on_Equipment_sort_children() -> void:
	var offset = ($MarginContainer.get("custom_constants/margin_right") / 2)
	$Close.rect_position = Vector2(rect_size.x - $Close.rect_size.x / 2 - offset, -$Close.rect_size.y / 2 + offset) 

func _on_Close_pressed() -> void:
	hide()
