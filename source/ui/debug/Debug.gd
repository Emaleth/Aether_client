extends PanelContainer

onready var latency_label = $VBoxContainer/Latency


func conf(_latency):
	latency_label.text = "Latency: %s" % _latency
