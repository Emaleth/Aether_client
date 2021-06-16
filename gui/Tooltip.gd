extends PanelContainer

onready var name_label = $VBoxContainer/Name
onready var icon_rect = $VBoxContainer/Icon
onready var description_label = $VBoxContainer/Description
onready var strenght = $VBoxContainer/Stats/Strenght
onready var dexterity = $VBoxContainer/Stats/Dexterity
onready var constitution = $VBoxContainer/Stats/Constitution
onready var intelligence = $VBoxContainer/Stats/Intelligence
onready var wisdome = $VBoxContainer/Stats/Wisdome
onready var stat_container = $VBoxContainer/Stats

func conf(name : String = "", icon : Texture = null, description : String = "", stats : Dictionary = {}):
	yield(self, "ready")
	if name == "":
		name_label.hide()
	else:
		name_label.text = name
	if icon == null:
		icon_rect.hide()
	else:
		icon_rect.texture = icon
	if description == "":
		description_label.hide()
	else:
		description_label.text = description
	if stats.size() == 0:
		stat_container.hide()
	else:
		if stats.strenght != null:
			strenght.get_node("Name").text = "STR"
			strenght.get_node("Value").text = stats.strenght
		else:
			strenght.hide()
		if stats.dexterity != null:
			dexterity.get_node("Name").text = "DEX"
			dexterity.get_node("Value").text = stats.dexterity
		else:
			dexterity.hide()
	
		if stats.constitution != null:
			constitution.get_node("Name").text = "CONST"
			constitution.get_node("Value").text = stats.constitution
		else:
			constitution.hide()
		
		if stats.intelligence != null:
			intelligence.get_node("Name").text = "INT"
			intelligence.get_node("Value").text = stats.intelligence
		else:
			intelligence.hide()
		
		if stats.wisdome != null:
			wisdome.get_node("Name").text = "WIS"
			wisdome.get_node("Value").text = stats.wisdome
		else:
			wisdome.hide()
		
