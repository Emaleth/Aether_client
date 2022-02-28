extends PanelContainer


onready var strenght_label := $VBoxContainer/Strenght
onready var dexterity_label := $VBoxContainer/Dexterity
onready var intelligence_label := $VBoxContainer/Intelligence
onready var wisdome_label := $VBoxContainer/Wisdome
onready var stamina_label := $VBoxContainer/Stamina


func update_data(_data):
	strenght_label.text = "str: %s" % _data["str"]
	dexterity_label.text = "dex: %s" % _data["dex"]
	intelligence_label.text = "int: %s" % _data["int"]
	wisdome_label.text = "wis: %s" % _data["wis"]
	stamina_label.text = "sta: %s" % _data["sta"]
	
	
func _ready() -> void:
	update_data(GlobalVariables.attributes_data)
