extends PanelContainer

onready var container = $VBoxContainer

onready var item_name_label = $VBoxContainer/ItemNameContainer/ItemName
onready var item_description_label = $VBoxContainer/ItemDescriptionContainer/ItemDescription

onready var item_stats_name_column = $VBoxContainer/ItemStatsContainer/ItemStats/name
onready var item_stats_value_column = $VBoxContainer/ItemStatsContainer/ItemStats/value
onready var item_stats_delta_column = $VBoxContainer/ItemStatsContainer/ItemStats/delta

onready var item_attributes_name_column = $VBoxContainer/ItemAttributesContainer/ItemAttributes/name
onready var item_attributes_value_column = $VBoxContainer/ItemAttributesContainer/ItemAttributes/value
onready var item_attributes_delta_column = $VBoxContainer/ItemAttributesContainer/ItemAttributes/delta

# PANELS
onready var item_name_panel = $VBoxContainer/ItemNameContainer
onready var item_description_panel = $VBoxContainer/ItemDescriptionContainer
onready var item_stats_panel = $VBoxContainer/ItemStatsContainer
onready var item_attributes_panel = $VBoxContainer/ItemAttributesContainer
onready var skill_tooltip = $VBoxContainer/SkillTooltip

func conf(item_name : String = "", item_description : String = "", item_stats : Dictionary = {}, item_attributes : Dictionary = {}, item_rarity : String = "", item_skill : Dictionary = {}):
	if not is_inside_tree():
		yield(self, "ready")
#	var star_num = 0
	if item_rarity:
		match item_rarity:
			"COMMON":
				item_name_label.self_modulate = Color.whitesmoke
#				star_num = 1
			"UNCOMMON":
				item_name_label.self_modulate = Color.green
#				star_num = 2
			"RARE":
				item_name_label.self_modulate = Color.blue
#				star_num = 3
			"EPIC":
				item_name_label.self_modulate = Color.purple
#				star_num = 4
			"LEGENDARY":
				item_name_label.self_modulate = Color.yellow
#				star_num = 5
	if item_name == "":
		item_name_panel.hide()
	else:
#		item_name_label.text = ("★".repeat(star_num) + " %s " + "★".repeat(star_num)) % item_name
		item_name_label.text = item_name
		
	if item_skill.size() == 0:
		skill_tooltip.hide()
	else:
		skill_tooltip.conf(item_skill.skill_name, item_skill.skill_description, item_skill.skill_cost, item_skill.skill_params)
		
	if item_description == "":
		item_description_panel.hide()
	else:
		item_description_label.text = item_description
		
	if item_stats.size() == 0:
		item_stats_panel.hide()
	else:
		for i in item_stats:
			if item_stats.get(i):
				var new_name_label = item_stats_name_column.get_node("template").duplicate()
				var new_value_label = item_stats_value_column.get_node("template").duplicate()
				var new_delta_label = item_stats_delta_column.get_node("template").duplicate()
				new_name_label.text = str(i)
				new_value_label.text = str(item_stats.get(i))
				new_delta_label.text = "+x"
				item_stats_name_column.add_child(new_name_label)
				item_stats_value_column.add_child(new_value_label)
				item_stats_delta_column.add_child(new_delta_label)
				new_name_label.show()
				new_value_label.show()
				new_delta_label.show()
			
	if item_attributes.size() == 0:
		item_attributes_panel.hide()
	else:
		for i in item_attributes:
			if item_attributes.get(i):
				var new_name_label = item_attributes_name_column.get_node("template").duplicate()
				var new_value_label = item_attributes_value_column.get_node("template").duplicate()
				var new_delta_label = item_attributes_delta_column.get_node("template").duplicate()
				new_name_label.text = str(i)
				new_value_label.text = str(item_attributes.get(i))
				new_delta_label.text = "+x"
				item_attributes_name_column.add_child(new_name_label)
				item_attributes_value_column.add_child(new_value_label)
				item_attributes_delta_column.add_child(new_delta_label)
				new_name_label.show()
				new_value_label.show()
				new_delta_label.show()
			
func _on_VBoxContainer_sort_children() -> void:
	rect_min_size = container.rect_size
	rect_position.x = min(rect_position.x, OS.get_screen_size().x - rect_size.x)
	rect_position.y = min(rect_position.y, OS.get_screen_size().y - rect_size.y)
