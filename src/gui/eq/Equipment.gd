extends WindowDialog

var equipment : Dictionary = {
	"mainhand" : null,
	"offhand" : null,
	"boots" : null,
	"gloves" : null,
	"torso" : null,
	"helmet" : null,
	"cape" : null
}


func _ready() -> void:
	window_title = tr("00013")
	equipment.mainhand = $MarginContainer/GridContainer/MainHand
	equipment.offhand = $MarginContainer/GridContainer/OffHand

func _on_MarginContainer_sort_children() -> void:
	rect_min_size = $MarginContainer.rect_min_size
	rect_size = $MarginContainer.rect_size

func conf(actor):
	for i in actor.equipment:
		if equipment.get(i):
			equipment.get(i).conf(actor, i, "equipment")

func can_drop_data(position: Vector2, data) -> bool:
	return false
		


