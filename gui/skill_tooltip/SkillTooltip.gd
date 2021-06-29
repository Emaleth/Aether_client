extends PanelContainer

onready var container = $VBoxContainer

onready var skill_name_label = $VBoxContainer/SkillNameContainer/SkillName
onready var skill_description_label = $VBoxContainer/SkillDescriptionContainer/SkillDescription

onready var skill_cost_name_column = $VBoxContainer/SkillCostContainer/SkillCost/name
onready var skill_cost_value_column = $VBoxContainer/SkillCostContainer/SkillCost/value

onready var skill_params_name_column = $VBoxContainer/SkillParamsContainer/SkillParams/name
onready var skill_params_value_column = $VBoxContainer/SkillParamsContainer/SkillParams/value

onready var skill_target_name_column = $VBoxContainer/SkillTargetContainer/SkillTarget/name
onready var skill_target_value_column = $VBoxContainer/SkillTargetContainer/SkillTarget/value

onready var skill_name_panel = $VBoxContainer/SkillNameContainer
onready var skill_description_panel = $VBoxContainer/SkillDescriptionContainer
onready var skill_cost_panel = $VBoxContainer/SkillCostContainer
onready var skill_params_panel = $VBoxContainer/SkillParamsContainer
onready var skill_target_panel = $VBoxContainer/SkillTargetContainer

func conf(skill_name : String = "", skill_description : String = "", skill_params : Dictionary = {}, skill_cost : Dictionary = {}, skill_target : Dictionary = {}):
	if not is_inside_tree():
		yield(self, "ready")
	if skill_name == "":
		skill_name_panel.hide()
	else:
		skill_name_label.text = skill_name
		
	if skill_description == "":
		skill_description_panel.hide()
	else:
		skill_description_label.text = skill_description
		
	if skill_params.size() == 0:
		skill_params_panel.hide()
	else:
		for i in skill_params:
			if skill_params.get(i):
				var new_name_label = skill_params_name_column.get_node("template").duplicate()
				var new_value_label = skill_params_value_column.get_node("template").duplicate()
				new_name_label.text = str(i)
				new_value_label.text = str(skill_params.get(i))
				skill_params_name_column.add_child(new_name_label)
				skill_params_value_column.add_child(new_value_label)
				new_name_label.show()
				new_value_label.show()
		if skill_params_name_column.get_child_count() == 1:
			skill_params_panel.hide()
			
	if skill_cost.size() == 0:
		skill_cost_panel.hide()
	else:
		for i in skill_cost:
			if skill_cost.get(i):
				var new_name_label = skill_cost_name_column.get_node("template").duplicate()
				var new_value_label = skill_cost_value_column.get_node("template").duplicate()
				new_name_label.text = str(i)
				new_value_label.text = str(skill_cost.get(i))
				skill_cost_name_column.add_child(new_name_label)
				skill_cost_value_column.add_child(new_value_label)
				new_name_label.show()
				new_value_label.show()
		if skill_cost_name_column.get_child_count() == 1:
			skill_cost_panel.hide()
				
	if skill_target.size() == 0:
		skill_target_panel.hide()
	else:
		for i in skill_target:
			if skill_target.get(i):
				var new_name_label = skill_target_name_column.get_node("template").duplicate()
				var new_value_label = skill_target_value_column.get_node("template").duplicate()
				new_name_label.text = str(i)
				new_value_label.text = str(skill_target.get(i))
				skill_target_name_column.add_child(new_name_label)
				skill_target_value_column.add_child(new_value_label)
				new_name_label.show()
				new_value_label.show()
		if skill_target_name_column.get_child_count() == 1:
			skill_target_panel.hide()
			
func _on_VBoxContainer_sort_children() -> void:
	rect_min_size = container.rect_size
	rect_position.x = min(rect_position.x, OS.get_screen_size().x - rect_size.x)
	rect_position.y = min(rect_position.y, OS.get_screen_size().y - rect_size.y)
