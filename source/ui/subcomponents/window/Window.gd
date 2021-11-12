extends PanelContainer

enum type {PANEL, WINDOW}

export(type) var window_type = type.PANEL
export var window_title := ""

var editable = false
var mouse_offset : Vector2
var cell_size := Vector2.ONE

onready var top_bar = $VBoxContainer/TopBar
onready var window_content_panel := $VBoxContainer/ContentPanel
onready var window_title_label := $VBoxContainer/TopBar/HBoxContainer/Title
onready var panel_drag := $PanelDrag 

func _ready() -> void:
	get_grid()
	window_title_label.text = window_title
	if window_type == type.PANEL:
		snap_position_to_grid()
	elif window_type == type.WINDOW:
		top_bar.show()
		hide()
		
	snap_size_to_grid()
	enable_edit_mode(false)
		
func resize():
	get_grid()
	if window_type == type.PANEL:
		snap_position_to_grid()
	snap_size_to_grid()
	
func enable_edit_mode(_b : bool):
	editable = _b
	if _b:
		if window_type == type.PANEL:
			panel_drag.show()
		elif window_type == type.WINDOW:
			hide()
	else:
		if window_type == type.PANEL:
			panel_drag.hide()
#		elif window_type == type.WINDOW:
#			show()
			
func _on_TopBar_gui_input(event: InputEvent) -> void:
	if window_type == type.WINDOW:
		if !editable and Input.is_action_just_pressed("click"):
			mouse_offset = get_local_mouse_position()
			raise()
		elif !editable and mouse_offset and event is InputEventMouseMotion and Input.is_action_pressed("click") and !Input.is_action_just_pressed("click"):
			rect_global_position.x = clamp(get_global_mouse_position().x - mouse_offset.x, 0, get_parent().rect_size.x - rect_size.x)
			rect_global_position.y = clamp(get_global_mouse_position().y - mouse_offset.y, 0, get_parent().rect_size.y - rect_size.y)
		
func _on_Lock_toggled(button_pressed: bool) -> void:
	editable = button_pressed

func _on_Close_pressed() -> void:
	hide()

func snap_position_to_grid():
	rect_global_position = rect_global_position.snapped(Vector2.ONE * cell_size)

func snap_size_to_grid():
	rect_size = rect_min_size
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

func _on_PanelDrag_gui_input(event: InputEvent) -> void:
	if window_type == type.PANEL:
		if editable and Input.is_action_just_pressed("click"):
			mouse_offset = get_local_mouse_position()
			raise()
		elif editable and mouse_offset and event is InputEventMouseMotion and Input.is_action_pressed("click") and !Input.is_action_just_pressed("click"):
			rect_global_position.x = clamp(get_global_mouse_position().x - mouse_offset.x, 0, get_parent().rect_size.x - rect_size.x)
			rect_global_position.y = clamp(get_global_mouse_position().y - mouse_offset.y, 0, get_parent().rect_size.y - rect_size.y)
			snap_position_to_grid()

