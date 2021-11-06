extends PanelContainer

var item = null

onready var item_texture = $TextureRect


func configure(_item):
	item = _item
	if _item != null:
		hint_tooltip = generate_tooltip_text()
		item_texture.texture = get_item_icon()

		
func generate_tooltip_text() -> String:
	var tooltip_text := ""
	tooltip_text += str(item["archetype"])
	tooltip_text += str(LocalDataTables.item_table[item["archetype"]])
	return tooltip_text
	
func get_item_icon() -> Texture:
	var item_icon_path = "res://assets/icons/item//%s.png" % str(item["archetype"])
	var texture : Texture
	if ResourceLoader.exists(item_icon_path):
		texture = load(item_icon_path)
	else:
		texture = preload("res://assets/icons/item/no_icon.png")
	return texture
	
	
