extends WindowDialog

onready var slot_grid = $MarginContainer/grid
onready var slot_path = preload("res://src/gui/w_base/slot/Slot.tscn")

var actor_inv

var source_slot = {
	"slot" : null,
	"item" : "",
	"quantity" : 0,
}
var target_slot = {
	"slot" : null,
	"item" : "",
	"quantity" : 0,
}

func _ready() -> void:
	window_title = tr("00012")

func _on_MarginContainer_sort_children() -> void:
	rect_min_size = $MarginContainer.rect_min_size
	rect_size = $MarginContainer.rect_size

func conf(inv : Dictionary):
	actor_inv = inv
	for i in actor_inv:
#		print(i)
		var new_slot = slot_path.instance()
		slot_grid.add_child(new_slot)
		actor_inv.get(i).slot_node = new_slot
		new_slot.conf(self, actor_inv.get(i).item, actor_inv.get(i).quantity, i)
#	print(actor_inv)

func can_drop_data(position: Vector2, data) -> bool:
#	print(actor_inv)
	return false
		
