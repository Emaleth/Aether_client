extends PanelContainer

onready var main_grid = $HBoxContainer/Eq/EquipmentSlots/Main
onready var jewellry_grid = $HBoxContainer/Eq/EquipmentSlots/Jewellry
onready var amulet_grid = $HBoxContainer/Eq/EquipmentSlots/Amulets
onready var stat_container = $HBoxContainer/Stats/VBoxContainer/VBoxContainer/
onready var points_label = $HBoxContainer/Stats/VBoxContainer/VBoxContainer/PointsLabel

onready var equipment : Dictionary = {
	"head" :  main_grid.get_node("Head"),
	"hands" : main_grid.get_node("Hands"),
	"feet" : main_grid.get_node("Feet"),
	"upper_body" : main_grid.get_node("UpperBody"),
	"lower_body" : main_grid.get_node("LowerBody"),
	"cape" : main_grid.get_node("Cape"),
	"belt" : main_grid.get_node("Belt"),
	"shoulders" : main_grid.get_node("Shoulders"),
	"necklace" : jewellry_grid.get_node("Necklace"),
	"ring_1" : jewellry_grid.get_node("Ring1"),
	"ring_2" : jewellry_grid.get_node("Ring2"),
	"earring_1" : jewellry_grid.get_node("Earring1"),
	"earring_2" : jewellry_grid.get_node("Earring2"),
	"main_hand" : main_grid.get_node("MainHand"),
	"off_hand" : main_grid.get_node("OffHand"),
	"amulet_1" : amulet_grid.get_node("Amulet1"),
	"amulet_2" : amulet_grid.get_node("Amulet2"),
	"amulet_3" : amulet_grid.get_node("Amulet3")
	}
	
onready var stats = {
	"STR" : {
		"name" : stat_container.get_node("Strenght/Label"),
		"number" : stat_container.get_node("Strenght/Q"),
		"button" : stat_container.get_node("Strenght/Add")
	},
	"DEX" : {
		"name" : stat_container.get_node("Dexterity/Label"),
		"number" : stat_container.get_node("Dexterity/Q"),
		"button" : stat_container.get_node("Dexterity/Add")
	},
	"CONST" : {
		"name" : stat_container.get_node("Constitution/Label"),
		"number" : stat_container.get_node("Constitution/Q"),
		"button" : stat_container.get_node("Constitution/Add")
	},
	"INT" : {
		"name" : stat_container.get_node("Intelligence/Label"),
		"number" : stat_container.get_node("Intelligence/Q"),
		"button" : stat_container.get_node("Intelligence/Add")
	},
	"WIS" : {
		"name" : stat_container.get_node("Wisdom/Label"),
		"number" : stat_container.get_node("Wisdom/Q"),
		"button" : stat_container.get_node("Wisdom/Add")
	}
}

func _ready() -> void:
	$Close/TextureRect.self_modulate = Global.close_button
	for i in jewellry_grid.get_children():
		i.small()
	for i in amulet_grid.get_children():
		i.small()
		
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
	rect_size = $HBoxContainer.rect_size
	yield(get_tree(),"idle_frame")
	var offset = 4
	$Close.rect_position = Vector2(rect_size.x - $Close.rect_size.x / 2 - offset, -$Close.rect_size.y / 2 + offset) 

func _on_Close_pressed() -> void:
	hide()
