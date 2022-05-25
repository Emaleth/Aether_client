extends PanelContainer


onready var gold_label := $HBoxContainer/GoldLabel


func configure(_data):
	gold_label.text = "Gold: %s" % _data["gold"]
