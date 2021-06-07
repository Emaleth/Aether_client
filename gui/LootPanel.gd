extends PanelContainer

onready var slot_grid = $VBoxContainer/GridContainer
onready var slot_path = preload("res://gui/Slot.tscn")
	
func _ready() -> void:
	$Close/TextureRect.self_modulate = Global.close_button
	
func conf(actor, quantity_panel):
	if slot_grid.get_child_count() < actor.lootable.size():
		for old_slot in slot_grid.get_children():
			slot_grid.remove_child(old_slot)
			old_slot.queue_free()
		for i in actor.lootable:
			var new_slot = slot_path.instance()
			slot_grid.add_child(new_slot)
			new_slot.conf(actor, i, "lootable", quantity_panel)
	else:
		for i in actor.lootable:
			var new_slot = slot_grid.get_child(i)
			new_slot.conf(actor, i, "lootable", quantity_panel)

func _on_LootPanel_sort_children() -> void:
	var offset = 4
	$Close.rect_position = Vector2(rect_size.x - $Close.rect_size.x / 2 - offset, -$Close.rect_size.y / 2 + offset) 

func _on_Close_pressed() -> void:
	hide()
