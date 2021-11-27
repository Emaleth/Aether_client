extends "res://source/ui/subcomponents/window/Window.gd"

onready var slot = preload("res://source/ui/subcomponents/slot/Slot.tscn")
onready var slot_grid = $CenterContainer/ScrollContainer/GridContainer
onready var scroll_container = $CenterContainer/ScrollContainer
onready var scoll_bar = scroll_container.get_v_scrollbar()

var max_rows = 3


func configure(_data : Array):
	for i in slot_grid.get_children():
		i.hide()
		i.queue_free()
	for i in _data:
		var new_slot = slot.instance()
		slot_grid.add_child(new_slot)
		new_slot.configure(i, "inventory")
	calculate_scroll_container_size(ceil(_data.size() / float(slot_grid.columns)), slot_grid.get_constant("vseparation"), 40)
	resize()


func _ready() -> void:
	configure(GlobalVariables.inventory_data)
	hide_scroll_bar()


func hide_scroll_bar():
	scoll_bar.set("custom_styles/grabber_highlight", StyleBoxEmpty.new())
	scoll_bar.set("custom_styles/grabber", StyleBoxEmpty.new())
	scoll_bar.set("custom_styles/scroll_focus", StyleBoxEmpty.new())
	scoll_bar.set("custom_styles/scroll", StyleBoxEmpty.new())
	scoll_bar.set("custom_styles/grabber_pressed", StyleBoxEmpty.new())


func calculate_scroll_container_size(rows, v_sep, slot_y):
	var new_size_y = min(
			rows * slot_y + (rows  -1) * v_sep,
			max_rows * slot_y + (3 - 1) * v_sep
	)
	scroll_container.rect_min_size.y = new_size_y
	scroll_container.rect_size.y = new_size_y

