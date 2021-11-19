extends PanelContainer

onready var preview = $TextureRect
var item := {}


func conf(_item):
	item = _item

func _ready() -> void:
	var item_icon_path = "res://assets/icons/item//%s.svg" % str(item["archetype"])
	preview.texture = load(item_icon_path) if ResourceLoader.exists(item_icon_path) else preload("res://assets/icons/item/no_icon.svg")
	
