extends PanelContainer


onready var dex_box := $VBoxContainer/dex
onready var int_box := $VBoxContainer/int
onready var sta_box := $VBoxContainer/sta
onready var str_box := $VBoxContainer/str
onready var wis_box := $VBoxContainer/wis


func configure(_data):
	dex_box.get_node("Label").text ="Dexterity: %s" % _data["dex"]
	int_box.get_node("Label").text ="Intelligence: %s" % _data["int"]
	sta_box.get_node("Label").text ="Stamina: %s" % _data["sta"]
	str_box.get_node("Label").text ="Strenght: %s" % _data["str"]
	wis_box.get_node("Label").text ="Wisdom: %s" % _data["wis"]
