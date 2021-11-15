extends PanelContainer

var item = null
var container = null

onready var item_texture = $TextureRect
onready var drag_preview = preload("res://source/ui/drag_preview/DragPreview.tscn")

signal swap

func configure(_item, _container = null):
	item = _item
	container = _container
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
		var item_icon_path = "res://assets/icons/item//%s.svg" % str(item["archetype"])
		var texture : Texture
		if ResourceLoader.exists(item_icon_path):
			texture = load(item_icon_path)
		else:
			texture = preload("res://assets/icons/item/null.svg")
		return texture
	else:
		return null
		
func get_drag_data(_position: Vector2):
	if item != null:
		var data := {}
		data["container"] = container
		data["slot"] = self
		data["index"] = self.get_index()
		
		var new_drag_preview = drag_preview.instance()
		new_drag_preview.set_preview(item)
		set_drag_preview(new_drag_preview)

		return data

func can_drop_data(_position: Vector2, _data) -> bool:
	return true
	
func drop_data(_position: Vector2, _data) -> void:
#	if get_parent().has_method("swap_slots"):
	var data = {}
	data["container"] = container
	data["slot"] = self
	data["index"] = self.get_index()
#	if data["container"] == _data["container"] and data["container"] != "equipment":
#		Server.action_stack.append("something")
#		emit_signal("swap", _data, data)
#	else:
	Server.request_item_transfer(_data, data)
	
	
	
