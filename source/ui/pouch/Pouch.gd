extends "res://source/ui/subcomponents/window/Window.gd"

onready var slot = preload("res://source/ui/subcomponents/slot/Slot.tscn")
onready var slot_grid = $CenterContainer/GridContainer

var sc_index = 0
var x = [
	"item_slot_01", "item_slot_02",
	"item_slot_03", "item_slot_04", 
	"item_slot_05", "item_slot_06",
	"item_slot_07", "item_slot_08",
	"item_slot_09", "item_slot_10"
]


func _ready() -> void:
	yield(get_tree().create_timer(1),"timeout")
	configure(GlobalVariables.pouch_data)

func configure(_data : Array):
	sc_index = 0
	for i in slot_grid.get_children():
		i.hide()
		i.queue_free()
	for i in _data:
		var new_slot = slot.instance()
		slot_grid.add_child(new_slot)
		new_slot.configure(i, "pouch", x[sc_index])
		sc_index += 1
#		new_slot.connect("swap", self, "swap_slots")
	resize()

func swap_slots(slot_a, slot_b):
	slot_a["slot"].configure(slot_b["item"])
	slot_b["slot"].configure(slot_a["item"])



