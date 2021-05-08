extends WindowDialog


var actor_eq

var equipment : Dictionary = {
	"mainhand" : {
		"slot" : null,
		"item" : null
	},
	"offhand" : {
		"slot" : null,
		"item" : null
	},
	"boots" : {
		"slot" : null,
		"item" : null
	},
	"gloves" : {
		"slot" : null,
		"item" : null
	},
	"torso" : {
		"slot" : null,
		"item" : null
	},
	"helmet" : {
		"slot" : null,
		"item" : null
	},
	"cape" : {
		"slot" : null,
		"item" : null
	}
}


func _ready() -> void:
	window_title = tr("00013")
	equipment.mainhand.slot = $MarginContainer/GridContainer/MainHand
	equipment.offhand.slot = $MarginContainer/GridContainer/OffHand

func _on_MarginContainer_sort_children() -> void:
	rect_min_size = $MarginContainer.rect_min_size
	rect_size = $MarginContainer.rect_size

func conf(eq : Dictionary):
	actor_eq = eq
	for i in actor_eq:
		if equipment.get(i).slot:
			equipment.get(i).slot.conf(self, actor_eq.get(i).item, 1, NAN, true)
			print(equipment.get(i).item)
			print(equipment.get(i).slot)


func can_drop_data(position: Vector2, data) -> bool:
	return false
		
#

