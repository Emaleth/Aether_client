extends "res://source/ui/subcomponents/window/Window.gd"

onready var slot = preload("res://source/ui/subcomponents/slot/Slot.tscn")
onready var slot_grid = $VBoxContainer/ContentPanel/CenterContainer/GridContainer

var sc_index = 0
var x = [
	"skill_01",
	"skill_02",
	"skill_03",
	"skill_04",
	"skill_05",
	"skill_06",
	"skill_07",
	"skill_08",
	"skill_09",
	"skill_10"
]


func _ready() -> void:
	yield(get_tree().create_timer(1),"timeout")
	configure(GlobalVariables.spellbook_data)

func configure(_data : Array):
	sc_index = 0
	for i in slot_grid.get_children():
		i.queue_free()
	for i in _data:
		var new_slot = slot.instance()
		slot_grid.add_child(new_slot)
		new_slot.configure(i, "spellbook", x[sc_index])
		sc_index += 1
#		new_slot.connect("swap", self, "swap_slots")
		
func swap_slots(slot_a, slot_b):
	slot_a["slot"].configure(slot_b["item"])
	slot_b["slot"].configure(slot_a["item"])



