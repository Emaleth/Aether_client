extends PanelContainer

onready var container = $VBoxContainer

onready var title_label = $VBoxContainer/TitleContainer/Title
onready var icon_rect = $VBoxContainer/SkillContainer/SkillIcon
onready var body_label = $VBoxContainer/BodyContainer/Body
onready var stats_name_column = $VBoxContainer/StatsContainer/HBoxContainer/name
onready var stats_value_column = $VBoxContainer/StatsContainer/HBoxContainer/value
onready var stats_delta_column = $VBoxContainer/StatsContainer/HBoxContainer/delta
onready var attributes_name_column = $VBoxContainer/AttributesContainer/HBoxContainer/name
onready var attributes_value_column = $VBoxContainer/AttributesContainer/HBoxContainer/value
onready var attributes_delta_column = $VBoxContainer/AttributesContainer/HBoxContainer/delta
onready var footnote_label = $VBoxContainer/FootnoteContainer/Footnote
# PANELS
onready var title_panel = $VBoxContainer/TitleContainer
onready var skill_panel = $VBoxContainer/SkillContainer
onready var body_panel = $VBoxContainer/BodyContainer
onready var stats_panel = $VBoxContainer/StatsContainer
onready var attributes_panel = $VBoxContainer/AttributesContainer
onready var footnote_panel = $VBoxContainer/FootnoteContainer


func conf(name : String = "", icon : Texture = null, description : String = "", stats : Dictionary = {}, attributes : Dictionary = {}, rarity = null, footnote = ""):
	yield(self, "ready")
	var star_num = 0
	if rarity:
		match rarity:
			"COMMON":
				title_label.self_modulate = Color.whitesmoke
				star_num = 1
			"UNCOMMON":
				title_label.self_modulate = Color.green
				star_num = 2
			"RARE":
				title_label.self_modulate = Color.blue
				star_num = 3
			"EPIC":
				title_label.self_modulate = Color.purple
				star_num = 4
			"LEGENDARY":
				title_label.self_modulate = Color.yellow
				star_num = 5
	if name == "":
		title_panel.hide()
	else:
		title_label.text = ("★".repeat(star_num) + " %s " + "★".repeat(star_num)) % name
		
	if icon == null:
		skill_panel.hide()
	else:
		icon_rect.texture = icon
		
	if description == "":
		body_panel.hide()
	else:
		body_label.text = description
		
	if stats.size() == 0:
		stats_panel.hide()
	else:
		for i in stats:
			var new_name_label = stats_name_column.get_node("template").duplicate()
			var new_value_label = stats_value_column.get_node("template").duplicate()
			var new_delta_label = stats_delta_column.get_node("template").duplicate()
			new_name_label.text = str(i)
			new_value_label.text = str(stats.get(i))
			new_delta_label.text = "+x"
			stats_name_column.add_child(new_name_label)
			stats_value_column.add_child(new_value_label)
			stats_delta_column.add_child(new_delta_label)
			new_name_label.show()
			new_value_label.show()
			new_delta_label.show()
			
	if attributes.size() == 0:
		attributes_panel.hide()
	else:
		for i in attributes:
			var new_name_label = attributes_name_column.get_node("template").duplicate()
			var new_value_label = attributes_value_column.get_node("template").duplicate()
			var new_delta_label = attributes_delta_column.get_node("template").duplicate()
			new_name_label.text = str(i)
			new_value_label.text = str(attributes.get(i))
			new_delta_label.text = "+x"
			attributes_name_column.add_child(new_name_label)
			attributes_value_column.add_child(new_value_label)
			attributes_delta_column.add_child(new_delta_label)
			new_name_label.show()
			new_value_label.show()
			new_delta_label.show()
			
	if footnote == "":
		footnote_panel.hide()
	else:
		footnote_label.text = footnote

			
func _on_VBoxContainer_sort_children() -> void:
	rect_size = container.rect_size

