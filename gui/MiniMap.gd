extends PanelContainer

var max_zoom = 70
var min_zoom = 30
var zoom_speed = 20
var max_map_size = 300
var default_map_size = 200

onready var min_map_size = $ButtonList.rect_size.y
onready var camera = $ViewportContainer/Viewport/MiniMapCamera
onready var button_container = $ButtonList
onready var zoom_in = $ButtonList/ZoomIn
onready var zoom_out = $ButtonList/ZoomOut
onready var resize = $ButtonList/Resize

func _ready() -> void:
	rect_size = Vector2(default_map_size, default_map_size)
	rect_position.x = OS.window_size.x - rect_size.x
	$ButtonList/ZoomIn/image.self_modulate = Global.button_normal
	$ButtonList/ZoomOut/image.self_modulate = Global.button_normal
	$ButtonList/Resize/image.self_modulate = Global.button_normal
	
func _process(delta: float) -> void:
	if zoom_in.pressed == true:
		if camera.size > min_zoom:
			camera.size -= zoom_speed * delta
	if zoom_out.pressed == true:
		if camera.size < max_zoom:
			camera.size += zoom_speed * delta
			
	if resize.pressed == true:
		var new_size_x = OS.window_size.x - (get_global_mouse_position().x - resize.rect_size.x / 2)
		var new_size_y = get_global_mouse_position().y + resize.rect_size.y / 2
		rect_size = Vector2(
			max(clamp(new_size_x, min_map_size, max_map_size), clamp(new_size_y, min_map_size, max_map_size)),
			max(clamp(new_size_x, min_map_size, max_map_size), clamp(new_size_y, min_map_size, max_map_size))
			)
		rect_position.x = OS.window_size.x - rect_size.x

func _on_MiniMap_sort_children() -> void:
	var offset = 4
	button_container.rect_position = Vector2(-offset, rect_size.y - button_container.rect_size.y + offset)
