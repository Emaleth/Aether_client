extends Button

var aactor
var ttype
var sslot

onready var texture = $TextureRect
onready var quantity_label = $Label

signal request_swap
signal request_use

var preview = preload("res://src/gui/drag/DragPreview.tscn")

func _ready() -> void:
	quantity_label.text = ""
	disabled = true
	
func conf(actor, slot, type, empty_icon = null):
	aactor = actor
	ttype = type
	sslot = slot
	if not is_connected("request_swap", actor, "move_item"):
		connect("request_swap", actor, "move_item")
	if actor.get(type).get(slot).item && actor.get(type).get(slot).quantity > 0:
		if DataLoader.item_db.get(actor.get(type).get(slot).item).CONSUMABLE == true:
			disabled = false
			if not is_connected("request_use", actor, "use_item"):
				connect("request_use", actor, "use_item")
		else:
			disabled = true
			if is_connected("request_use", actor, "use_item"):
				disconnect("request_use", actor, "use_item")
		texture.texture = load("res://previews/%s.png" % actor.get(type).get(slot).item)
		hint_tooltip = "wierd fuckery"
		if actor.get(type).get(slot).quantity > 1:
			quantity_label.text = str(actor.get(type).get(slot).quantity)
		else:
			quantity_label.text = ""
	else:
		disabled = true
		if empty_icon:
			texture.texture = empty_icon
		else:
			texture.texture = null
		hint_tooltip = ""
		quantity_label.text = ""
		
func get_drag_data(position: Vector2):
	var my_data = [aactor, ttype, sslot]
	make_preview()
	return my_data

func can_drop_data(position: Vector2, data) -> bool:
	return true
	
func drop_data(position: Vector2, data) -> void:
	var source = data
	var target = [aactor, ttype, sslot]
	emit_signal("request_swap", source, target)

func _on_Slot_pressed() -> void: 
	if DataLoader.item_db.get(aactor.get(ttype).get(sslot).item).CONSUMABLE == true:
		var source = [aactor, ttype, sslot]
		emit_signal("request_use", source)

func make_preview():
	var pw = preview.instance()
	pw.get_node("CanvasLayer/TextureRect").texture = texture.texture
	set_drag_preview(pw)

func _make_custom_tooltip(for_text):
	if aactor.get(ttype).get(sslot).item:
		var tooltip = preload("res://src/gui/tooltip/Tooltip.tscn").instance()
		tooltip.item_name = DataLoader.item_db.get(aactor.get(ttype).get(sslot).item).NAME
	#	tooltip.description = item_description
	#	tooltip.stats = item_stats
		return tooltip
		
