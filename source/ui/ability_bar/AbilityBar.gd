extends "res://source/ui/subcomponents/window/Window.gd"

onready var slot = preload("res://source/ui/subcomponents/slot/Slot.tscn")
onready var slot_grid = $CenterContainer/GridContainer

var sc_index = 0
var x = [
	"ability_slot_01", "ability_slot_02",
	"ability_slot_03", "ability_slot_04", 
	"ability_slot_05", "ability_slot_06",
	"ability_slot_07", "ability_slot_08",
	"ability_slot_09", "ability_slot_10",
	"ability_slot_11", "ability_slot_12",
	"ability_slot_13", "ability_slot_14",
	"ability_slot_15", "ability_slot_16",
	"ability_slot_17", "ability_slot_18",
	"ability_slot_19", "ability_slot_20"
]


func _ready() -> void:
	yield(get_tree().create_timer(1),"timeout")
	configure(GlobalVariables.spellbook_data)


func configure(_data : Array):
	sc_index = 0
	for i in slot_grid.get_children():
		i.hide()
		i.queue_free()
	for i in _data:
		var new_slot = slot.instance()
		slot_grid.add_child(new_slot)
		new_slot.configure(i, "spellbook", x[sc_index])
		sc_index += 1
	resize()


