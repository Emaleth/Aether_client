extends PanelContainer

var item = null
var container = null

onready var item_texture = $TextureRect
onready var amount_label = $GridContainer/AmountLabel
onready var preview = preload("res://source/ui/drag_preview/DragPreview.tscn")
onready var tooltip = preload("res://source/ui/tooltip/Tooltip.tscn")

signal swap


func configure(_item, _container = null):
	item = _item
	container = _container
	set_tooltip_text()
	set_item_icon()
	set_amount_label()
	
func set_tooltip_text() -> void:
	hint_tooltip = "text" if item else ""

func _make_custom_tooltip(for_text: String) -> Control:
	var new_tooltip = tooltip.instance()
	new_tooltip.conf(item)
	return new_tooltip
		
func set_item_icon() -> void:
	if item:
		var item_icon_path = "res://assets/icons/item//%s.svg" % str(item["archetype"])
		item_texture.texture = load(item_icon_path) if ResourceLoader.exists(item_icon_path) else preload("res://assets/icons/item/no_icon.svg")
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
		var new_preview = preview.instance()
		new_preview.conf(item)
		set_drag_preview(new_preview)

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
	
	
	
