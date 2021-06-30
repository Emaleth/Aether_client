extends PanelContainer

var slot = preload("res://gui/slot/Slot.tscn")
onready var grid = $GridContainer
var selected_slot = 0
	
func conf(quickbar, quantity_panel):
	for old_slot in grid.get_children():
		grid.remove_child(old_slot)
		old_slot.queue_free()
	for i in quickbar:
		var new_slot = slot.instance()
		grid.add_child(new_slot)
		new_slot.conf(quickbar, i, quantity_panel)
		
	grid.get_child(selected_slot).get_node("Selector").show()
	
func _unhandled_input(_event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("next_skill"):
		grid.get_child(selected_slot).get_node("Selector").hide()
		selected_slot = clamp(selected_slot + 1, 0, grid.get_child_count()-1)
		grid.get_child(selected_slot).get_node("Selector").show()
	if Input.is_action_just_pressed("previous_skill"):
		grid.get_child(selected_slot).get_node("Selector").hide()
		selected_slot = clamp(selected_slot - 1, 0, grid.get_child_count()-1)
		grid.get_child(selected_slot).get_node("Selector").show()

	if Input.is_action_just_pressed("primary_action"):
		grid.get_child(selected_slot)._on_Slot_pressed()

#	if Input.is_action_just_pressed("secondary_action"):
#		get_selected()
	
