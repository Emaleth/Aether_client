extends PanelContainer

var window_height_in_slots = 5
var grid_v_separation = 4

onready var buttons = {
	"everything" : {
		"button" : $MarginContainer/VBoxContainer/SlotSelector/Everything,
		"on_icon" : preload("res://textures/icons/amulet_icon.png"), 
		"off_icon" : null
		},
	"weapon" : {
		"button" : $MarginContainer/VBoxContainer/SlotSelector/Weapon,
		"on_icon" : null, 
		"off_icon" : null
		},
	"armor" : {
		"button" : $MarginContainer/VBoxContainer/SlotSelector/Armor,
		"on_icon" : null, 
		"off_icon" : null
		},
	"jewelery" : {
		"button" : $MarginContainer/VBoxContainer/SlotSelector/Jewelry,
		"on_icon" : null, 
		"off_icon" : null
		},
	"ammunition" : {
		"button" : $MarginContainer/VBoxContainer/SlotSelector/Ammunition,
		"on_icon" : preload("res://textures/icons/ammunition_icon.png"), 
		"off_icon" : null
		},
	"consumable" : {
		"button" : $MarginContainer/VBoxContainer/SlotSelector/Consumable,
		"on_icon" : null, 
		"off_icon" : null
		},
	"tool" : {
		"button" : $MarginContainer/VBoxContainer/SlotSelector/Tool,
		"on_icon" : null, 
		"off_icon" : null
		},
	"material" : {
		"button" : $MarginContainer/VBoxContainer/SlotSelector/Material,
		"on_icon" : null, 
		"off_icon" : null
		}
	}
	
onready var slot_grid = $MarginContainer/VBoxContainer/ScrollContainer/grid
onready var scroll = $MarginContainer/VBoxContainer/ScrollContainer
onready var slot_selector = $MarginContainer/VBoxContainer/SlotSelector
onready var slot_path = preload("res://src/gui/w_base/slot/Slot.tscn")


func _ready() -> void:
	scroll.rect_min_size.y = ((window_height_in_slots * 40) + ((window_height_in_slots -1) * grid_v_separation))
	connect_button()
	
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
			buttons.get(i).button.icon = buttons.get(i).on_icon
		else:
			buttons.get(i).button.icon = buttons.get(i).off_icon
			
func connect_button():
	for i in buttons:
		buttons.get(i).button.connect("pressed", self, "show_slot_type", [i])
