extends WindowDialog


func _ready() -> void:
	window_title = tr("00012")

func _on_MarginContainer_sort_children() -> void:
	rect_min_size = $MarginContainer.rect_min_size
	rect_size = $MarginContainer.rect_size

func conf(inv : Dictionary):
	var slot_index = 0
	for i in inv:
		var slot = $MarginContainer/materials.get_child(slot_index)
		slot.conf(i, inv.get(i).quantity)
		slot_index += 1
