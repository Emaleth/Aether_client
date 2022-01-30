extends PanelContainer


export var alternative := false

onready var slot = preload("res://source/ui/subcomponents/slot/Slot.tscn")
onready var slot_grid = $GridContainer

var x = [
	"ability_slot_01", "ability_slot_02",
	"ability_slot_03", "ability_slot_04", 
	"ability_slot_05", "ability_slot_06",
	"ability_slot_07", "ability_slot_08",
	"ability_slot_09", "ability_slot_10"
]


func _ready() -> void:
	yield(get_tree().create_timer(1),"timeout")
	configure(GlobalVariables.spellbook_data)


func configure(_data : Array):
	var index = 0
	for i in slot_grid.get_children():
		i.hide()
		i.queue_free()
	for i in _data:
		var new_slot = slot.instance()
		slot_grid.add_child(new_slot)
		new_slot.alternative = alternative
		new_slot.configure(i, "spellbook", index, x[index], false)
		index += 1
	


