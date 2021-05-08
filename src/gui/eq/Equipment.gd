extends WindowDialog


var actor_eq

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
	window_title = tr("00013")

func _on_MarginContainer_sort_children() -> void:
	rect_min_size = $MarginContainer.rect_min_size
	rect_size = $MarginContainer.rect_size

func conf(eq : Dictionary):
	actor_eq = eq
	for i in actor_eq:
		print(i)
#		print(actor_eq.get(i))
#		print(actor_eq.get(i).slot)
#		print(actor_eq.get(i).item)
#		var new_slot = slot_path.instance()
#		slot_grid.add_child(new_slot)
#		actor_eq.get(i).slot_node = new_slot
#		new_slot.conf(self, actor_eq.get(i).item, actor_eq.get(i).quantity, i)
##	print(actor_inv)

func can_drop_data(position: Vector2, data) -> bool:
#	print(actor_inv)
	return false
		
		
func conf_slots():
	$slot.type = "mainhand"
	$slot.type = "offhand"
	$slot.type = "boots"
	$slot.type = "gloves"
	$slot.type = "torso"
	$slot.type = "helmet"
	$slot.type = "cape"

