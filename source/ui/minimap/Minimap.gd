extends "res://source/ui/subcomponents/window/Window.gd"

onready var camera_pivot = $VBoxContainer/ContentPanel/Viewport/Spatial

func _ready() -> void:
	window_title_label.text = "minimap"
	
func get_pivot_path():
	var pivot = camera_pivot.get_path()
	return pivot
