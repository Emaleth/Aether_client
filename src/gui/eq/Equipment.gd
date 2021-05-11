extends WindowDialog

onready var equipment : Dictionary = {
	"mainhand" : {
		"slot" : $MarginContainer/GridContainer/MainHand,
		"empty_icon" : preload("res://textures/empty_slots/mainhand.png")
	},
	"offhand" : {
		"slot" : $MarginContainer/GridContainer/OffHand,
		"empty_icon" : preload("res://textures/empty_slots/offhand.png")
	},
	"boots" : {
		"slot" : $MarginContainer/GridContainer/Boots,
		"empty_icon" : preload("res://textures/empty_slots/boots.png")
	},
	"gloves" : {
		"slot" : $MarginContainer/GridContainer/Gloves,
		"empty_icon" : preload("res://textures/empty_slots/gloves.png")
	},
	"torso" : {
		"slot" : $MarginContainer/GridContainer/Torso,
		"empty_icon" : preload("res://textures/empty_slots/torso.png")
	},
	"helmet" : {
		"slot" : $MarginContainer/GridContainer/Helmet,
		"empty_icon" : preload("res://textures/empty_slots/helmet.png")
	},
	"cape" : {
		"slot" : $MarginContainer/GridContainer/Cape,
		"empty_icon" : preload("res://textures/empty_slots/cape.png")
	}
}

func _ready() -> void:
	window_title = tr("00013")

func _on_MarginContainer_sort_children() -> void:
	rect_min_size = $MarginContainer.rect_min_size
	rect_size = $MarginContainer.rect_size

func conf(actor):
	for i in actor.equipment:
		equipment.get(i).slot.conf(actor, i, "equipment", equipment.get(i).empty_icon)

func can_drop_data(position: Vector2, data) -> bool:
	return false
		


