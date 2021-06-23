extends PanelContainer

var window_height_in_slots = 5
var grid_v_separation = 4

onready var scroll_container = $VBoxContainer/HBoxContainer/Magic/ScrollContainer
onready var slot_path = preload("res://gui/slot/Slot.tscn")
onready var slot_grid = $VBoxContainer/HBoxContainer/Magic/ScrollContainer/GridContainer


func _ready() -> void:
	scroll_container.rect_min_size.y = ((window_height_in_slots * 40) + ((window_height_in_slots -1) * grid_v_separation))
	$Close/TextureRect.self_modulate = Global.close_button
	
func _on_Close_pressed() -> void:
	hide()

func _on_SkillPanel_sort_children() -> void:
	var offset = 4
	$Close.rect_position = Vector2(rect_size.x - $Close.rect_size.x / 2 - offset, -$Close.rect_size.y / 2 + offset) 

func conf(actor):
	for old_slot in slot_grid.get_children():
		slot_grid.remove_child(old_slot)
		old_slot.queue_free()
	for i in actor.spellbook:
		var new_slot = slot_path.instance()
		slot_grid.add_child(new_slot)
		new_slot.conf(actor, i, "spellbook")
