extends PanelContainer

var max_zoom = 70
var min_zoom = 30
var zoom_speed = 20

onready var camera = $ViewportContainer/Viewport/MiniMapCamera
	
#func _process(delta: float) -> void:
#	if zoom_in.pressed == true:
#		if camera.size > min_zoom:
#			camera.size -= zoom_speed * delta
#	if zoom_out.pressed == true:
#		if camera.size < max_zoom:
#			camera.size += zoom_speed * delta

