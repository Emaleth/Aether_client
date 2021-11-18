extends PanelContainer

var item = null
var container = null

onready var item_texture = $TextureRect
onready var drag_preview = preload("res://source/ui/drag_preview/DragPreview.tscn")
onready var amount_label = $GridContainer/AmountLabel

signal swap


func configure(_item, _container = null):
	item = _item
	container = _container
	hint_tooltip = generate_tooltip_text()
	set_item_icon()
	set_amount_label()
	
func generate_tooltip_text() -> String:
	if item:
		var tooltip_text := ""
		tooltip_text += str(item["archetype"])
		tooltip_text += str(LocalDataTables.item_table[item["archetype"]])
		return tooltip_text
	else:
		return ""
		
func set_item_icon() -> void:
	if item:
		var item_icon_path = "res://assets/icons/item//%s.svg" % str(item["archetype"])
		item_texture.texture = load(item_icon_path) if ResourceLoader.exists(item_icon_path) else preload("res://assets/icons/item/null.svg")
	else:
		item_texture.texture = null

func set_amount_label() -> void:
	if item:
		amount_label.text = "" if item["amount"] == 1 else str(item["amount"])
	else:
		amount_label.text = ""
		
func get_drag_data(_position: Vector2):
	if item != null:
		var data := {
			"container" : container,
#			"slot" : self,
			"index" : self.get_index(),
			"amount" : item["amount"]
		}
		var new_drag_preview = drag_preview.instance()
		new_drag_preview.set_preview(item)
		set_drag_preview(new_drag_preview)

		return data

func can_drop_data(_position: Vector2, _data) -> bool:
	return true
	
func drop_data(_position: Vector2, _data) -> void:
#	if get_parent().has_method("swap_slots"):
	var data = {
		"container" : container,
#		"slot" : self,
		"index" : self.get_index(),
		"amount" : item["amount"] if item else null 
	}
#	if data["container"] == _data["container"] and data["container"] != "equipment":
#		Server.action_stack.append("something")
#		emit_signal("swap", _data, data)
#	else:
	Server.request_item_transfer(_data, -1, data)
	
	
	
