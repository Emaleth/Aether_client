extends PanelContainer

onready var camera_pivot = $Viewport/Spatial

func get_pivot_path():
	var pivot = camera_pivot.get_path()
	return pivot
