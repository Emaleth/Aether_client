extends PanelContainer

var window_height_in_slots = 5
var grid_v_separation = 4

onready var slot_grid = $MarginContainer/VBoxContainer/ScrollContainer/grid
onready var scroll : ScrollContainer = $MarginContainer/VBoxContainer/ScrollContainer
onready var slot_selector = $MarginContainer/VBoxContainer/MarginContainer/MarginContainer/SlotSelector
onready var slot_path = preload("res://src/gui/w_base/slot/Slot.tscn")

onready var buttons = {
	"everything" : slot_selector.get_node("Inventory"),
	"weapon" : slot_selector.get_node("Weapon"),
	"armor" : slot_selector.get_node("Armor"),
	"jewelery" : slot_selector.get_node("Jewelry"),
	"ammunition" : slot_selector.get_node("Ammunition"),
	"consumable" : slot_selector.get_node("Consumable"),
	"tool" : slot_selector.get_node("Tool"),
	"material" : slot_selector.get_node("Material")
	}
	
func _ready() -> void:
	scrollbar_theme()
	scroll.rect_min_size.y = ((window_height_in_slots * 40) + ((window_height_in_slots -1) * grid_v_separation))
	connect_button()
	show_slot_type("everything")
	
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
		
func show_slot_type(slot_type : String = ""):
	for slot in slot_grid.get_children():
		if slot_type == "everything":
			slot.show()
		else:
			if slot.aactor.get(slot.ttype).get(slot.sslot).item:
				if DataLoader.item_db.get(slot.aactor.get(slot.ttype).get(slot.sslot).item).TYPE == slot_type:
					slot.show()
				else:
					slot.hide()
	for i in buttons:
		if i == slot_type:
			buttons.get(i).self_modulate = Global.toggle_on
		else:
			buttons.get(i).self_modulate = Global.toggle_off
			
func connect_button():
	for i in buttons:
		buttons.get(i).connect("pressed", self, "show_slot_type", [i])

func scrollbar_theme():
	var grabber = StyleBoxTexture.new()
	grabber.texture = preload("res://textures/ui/grabber.png")
	grabber.margin_top = 6
	grabber.margin_bottom = 6
	var grabber_bg = StyleBoxTexture.new()
	grabber_bg.texture = preload("res://textures/ui/scrollbar_bg.png")
	scroll.get_v_scrollbar().add_stylebox_override("grabber_highlight", grabber)
	scroll.get_v_scrollbar().add_stylebox_override("grabber", grabber)
	scroll.get_v_scrollbar().add_stylebox_override("grabber_pressed", grabber)
	scroll.get_v_scrollbar().add_stylebox_override("scroll", grabber_bg)
	scroll.get_v_scrollbar().add_stylebox_override("scroll_focus", grabber_bg) 
