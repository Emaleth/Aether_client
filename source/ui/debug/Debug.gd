extends "res://source/ui/subcomponents/window/Window.gd"

onready var latency_label = $VBoxContainer/ContentPanel/VBoxContainer/Latency


func conf(_latency):
	latency_label.text = "Latency: %s" % _latency
