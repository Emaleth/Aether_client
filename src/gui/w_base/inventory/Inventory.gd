extends PanelContainer

var window_height_in_slots = 5
var grid_v_separation = 4

onready var slot_grid = $MarginContainer/VBoxContainer/ScrollContainer/grid
onready var scroll = $MarginContainer/VBoxContainer/ScrollContainer
onready var slot_selector = $MarginContainer/VBoxContainer/SlotSelector
onready var slot_path = preload("res://src/gui/w_base/slot/Slot.tscn")


func _ready() -> void:
	scroll.rect_min_size.y = ((window_height_in_slots * 40) + ((window_height_in_slots -1) * grid_v_separation))
	slot_selector.xxx = self
	
func conf(actor):
	if slot_grid.get_child_count() < actor.inventory.size():
		for old_slot in slot_grid.get_children():
			slot_grid.remove_child(old_slot)
			old_slot.queue_free()
		for i in actor.inventory:
			var new_slot = slot_path.instance()
			slot_grid.add_child(new_slot)
			new_slot.conf(actor, i, "inventory")
	else:
		for i in actor.inventory:
			var new_slot = slot_grid.get_child(i)
			new_slot.conf(actor, i, "inventory")

func can_drop_data(position: Vector2, data) -> bool:
	return false
		
func show_slots(slot_types : Array = []):
	for slot in slot_grid.get_children():
		if slot.aactor.get(slot.ttype).get(slot.sslot).item:
			if DataLoader.item_db.get(slot.aactor.get(slot.ttype).get(slot.sslot).item).TYPE in slot_types:
				slot.show()

func hide_slots(slot_types : Array = []):
	for slot in slot_grid.get_children():
		if slot.aactor.get(slot.ttype).get(slot.sslot).item:
			if DataLoader.item_db.get(slot.aactor.get(slot.ttype).get(slot.sslot).item).TYPE in slot_types:
				slot.hide()
