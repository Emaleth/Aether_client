extends PanelContainer

var max_zoom = 70
var min_zoom = 30
var zoom_speed = 20

onready var camera = $ViewportContainer/Viewport/MiniMapCamera
onready var zoom_in = $ButtonList/ZoomIn
onready var zoom_out = $ButtonList/ZoomOut


func _ready() -> void:
	$ButtonList/ZoomIn/image.self_modulate = Global.button_normal
	$ButtonList/ZoomOut/image.self_modulate = Global.button_normal
	
func _process(delta: float) -> void:
	if zoom_in.pressed == true:
		if camera.size > min_zoom:
			camera.size -= zoom_speed * delta
	if zoom_out.pressed == true:
		if camera.size < max_zoom:
			camera.size += zoom_speed * delta
			
func conf(remote_transform):
	remote_transform.remote_path = camera.get_path()
