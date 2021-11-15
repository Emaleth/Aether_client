extends PanelContainer

onready var preview = $TextureRect

func set_preview(_item):
	var item_icon_path = "res://assets/icons/item//%s.svg" % str(_item["archetype"])
	var texture : Texture
	if ResourceLoader.exists(item_icon_path):
		texture = load(item_icon_path)
	else:
		texture = preload("res://assets/icons/item/null.svg")
	
	$TextureRect.texture = texture
