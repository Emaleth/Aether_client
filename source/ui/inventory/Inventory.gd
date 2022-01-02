extends PanelContainer

onready var slot = preload("res://source/ui/subcomponents/slot/Slot.tscn")
onready var slot_grid = $VBoxContainer/CenterContainer/ScrollContainer/GridContainer
onready var scroll_container = $VBoxContainer/CenterContainer/ScrollContainer
onready var scoll_bar = scroll_container.get_v_scrollbar()
onready var gold_label = $VBoxContainer/HBoxContainer/Label 

var max_rows = 5


func configure(_data : Array):
	for i in slot_grid.get_children():
		i.hide()
		i.queue_free()
	for i in _data:
		var new_slot = slot.instance()
		slot_grid.add_child(new_slot)
		new_slot.configure(i, "inventory")
	calculate_scroll_container_size(ceil(_data.size() / float(slot_grid.columns)), slot_grid.get_constant("vseparation"), 40)


func configure_currency(_data : Dictionary):
	gold_label.text = str(_data.gold)


func _ready() -> void:
	configure(GlobalVariables.inventory_data)
	configure_currency(GlobalVariables.currency_data)
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

