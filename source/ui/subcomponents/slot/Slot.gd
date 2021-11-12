extends PanelContainer

var item = null

onready var item_texture = $TextureRect
signal swap

func configure(_item):
	item = _item
	hint_tooltip = generate_tooltip_text()
	item_texture.texture = get_item_icon()
	
func generate_tooltip_text() -> String:
	if item:
		var tooltip_text := ""
		tooltip_text += str(item["archetype"])
		tooltip_text += str(LocalDataTables.item_table[item["archetype"]])
		return tooltip_text
	else:
		return ""
		
func get_item_icon() -> Texture:
	if item:
		var item_icon_path = "res://assets/icons/item//%s.png" % str(item["archetype"])
		var texture : Texture
		if ResourceLoader.exists(item_icon_path):
			texture = load(item_icon_path)
		else:
			texture = preload("res://assets/icons/item/interdiction.svg")
		return texture
	else:
		return null
		
func get_drag_data(_position: Vector2):
	var data := {}
	data["slot"] = self
	data["item"] = item
	return data

func can_drop_data(_position: Vector2, _data) -> bool:
	return true
	
func drop_data(_position: Vector2, _data) -> void:
#	if get_parent().has_method("swap_slots"):
	var data = {}
	data["slot"] = self
	data["item"] = item
	Server.request_item_transfer(_data, data)
#	emit_signal("swap", _data, data)
#		get_parent().swap_slots(_data, data)
	
	
	
	
