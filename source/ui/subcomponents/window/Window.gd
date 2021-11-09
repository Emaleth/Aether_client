extends PanelContainer

var locked
var mouse_offset : Vector2
var cell_size := 16

onready var window_title_label := $VBoxContainer/TopBar/HBoxContainer/Title
onready var window_content_panel := $VBoxContainer/ContentPanel

	
func _on_TopBar_gui_input(event: InputEvent) -> void:
	if !locked and Input.is_action_just_pressed("click"):
		mouse_offset = get_local_mouse_position()
		raise()
	elif !locked and mouse_offset and event is InputEventMouseMotion and Input.is_action_pressed("click") and !Input.is_action_just_pressed("click"):
		rect_global_position.x = clamp(get_global_mouse_position().x - mouse_offset.x, 0, get_parent().rect_size.x - rect_size.x)
		rect_global_position.y = clamp(get_global_mouse_position().y - mouse_offset.y, 0, get_parent().rect_size.y - rect_size.y)
		snap_position_to_grid()
		
func _on_Lock_toggled(button_pressed: bool) -> void:
	locked = button_pressed

func _on_Close_pressed() -> void:
	queue_free()

func _ready() -> void:
	snap_size_to_grid()
	snap_position_to_grid()
	
	
func _on_Window_resized() -> void:
	snap_size_to_grid()

func snap_position_to_grid():
	rect_global_position = rect_global_position.snapped(Vector2.ONE * cell_size)

func snap_size_to_grid():
	var size_x : int = rect_size.x
	var size_y : int = rect_size.y
	
	if size_x % cell_size != 0:
		size_x = stepify(size_x, cell_size) + cell_size

	if size_y % cell_size != 0:
		size_y = stepify(size_y, cell_size) + cell_size
	
	rect_min_size = Vector2(size_x, size_y)
	rect_size = Vector2(size_x, size_y)
