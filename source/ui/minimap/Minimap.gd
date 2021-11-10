extends "res://source/ui/subcomponents/window/Window.gd"

onready var camera_pivot = $VBoxContainer/ContentPanel/Viewport/Spatial


func get_pivot_path():
	var pivot = camera_pivot.get_path()
	return pivot
