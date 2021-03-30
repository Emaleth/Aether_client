extends HBoxContainer


onready var name_label = $Stat
onready var value_label = $Value
onready var diff_label = $Difference

func conf(n = "", v = "", d = "") -> void:
	name_label.text = n
	value_label = v
	diff_label = d
