extends PanelContainer

var editable = false
var mouse_offset : Vector2
var cell_size := Vector2.ONE

var drag_layer = null

onready var drag_layer_scene = preload("res://source/ui/subcomponents/drag_layer/DragLayer.tscn")


func _ready() -> void:
	rect_min_size = Vector2.ZERO
	add_drag_layer()
	resize()
	snap_position_to_grid()
	enable_edit_mode(false)
	
func add_drag_layer():
	drag_layer = drag_layer_scene.instance()
	add_child(drag_layer)
	drag_layer.connect("gui_input", self, "drag_window")

func resize():
	check_in_window()
	get_grid()
	snap_size_to_grid()
	
func check_in_window():
	rect_global_position.x = clamp(rect_global_position.x, 0, OS.window_size.x - rect_size.x)
	rect_global_position.y = clamp(rect_global_position.y, 0, OS.window_size.y - rect_size.y)
	
func enable_edit_mode(_b : bool):
	editable = _b
	drag_layer.visible = _b

func snap_position_to_grid():
	rect_global_position = rect_global_position.snapped(Vector2.ONE * cell_size)

func snap_size_to_grid():
	rect_size = Vector2.ZERO
	var size_x : float = rect_size.x
	var size_y : float = rect_size.y
	if floor(size_x / cell_size.x) != (size_x / cell_size.x):
		size_x = stepify(size_x, cell_size.x) + cell_size.x
	if floor(size_y / cell_size.y) != (size_y / cell_size.y):
		size_y = stepify(size_y, cell_size.y) + cell_size.y
	rect_size = Vector2(size_x, size_y)

func get_grid():
	cell_size.x = OS.window_size.x / 128
	cell_size.y = OS.window_size.y / 72

func drag_window(event: InputEvent) -> void:
	if editable and Input.is_action_just_pressed("click"):
		mouse_offset = get_local_mouse_position()
		raise()
	elif editable and mouse_offset and event is InputEventMouseMotion and Input.is_action_pressed("click") and !Input.is_action_just_pressed("click"):
		rect_global_position.x = get_global_mouse_position().x - mouse_offset.x
		rect_global_position.y = get_global_mouse_position().y - mouse_offset.y
	check_in_window()
	snap_position_to_grid()

