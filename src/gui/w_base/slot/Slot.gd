extends Button

var aactor
var ttype
var sslot

onready var quantity_label = $MarginContainer/Label

signal request_swap
signal request_use

var preview = preload("res://src/gui/drag/DragPreview.tscn")

func _ready() -> void:
	quantity_label.text = ""
	
func conf(actor, slot, type, empty_icon = null):
	aactor = actor
	ttype = type
	sslot = slot
	if not is_connected("request_swap", actor, "move_item"):
		connect("request_swap", actor, "move_item")
	if actor.get(type).get(slot).item && actor.get(type).get(slot).quantity > 0:
		if DataLoader.item_db.get(actor.get(type).get(slot).item).USABLE == true:
			if not is_connected("request_use", actor, "use_item"):
				connect("request_use", actor, "use_item")
		else:
			if is_connected("request_use", actor, "use_item"):
				disconnect("request_use", actor, "use_item")
		icon = load("res://previews/%s.png" % actor.get(type).get(slot).item)
		hint_tooltip = "wierd fuckery"
		if actor.get(type).get(slot).quantity > 1:
			quantity_label.text = str(actor.get(type).get(slot).quantity)
		else:
			quantity_label.text = ""
	else:
		if empty_icon:
			icon = empty_icon
		else:
			icon = null
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
	if DataLoader.item_db.get(aactor.get(ttype).get(sslot).item).USABLE == true:
		var source = [aactor, ttype, sslot]
		emit_signal("request_use", source)

func make_preview():
	var pw = preview.instance()
	pw.conf(icon)
	set_drag_preview(pw)

func _make_custom_tooltip(for_text):
	if aactor.get(ttype).get(sslot).item:
		var tooltip = preload("res://src/gui/tooltip/Tooltip.tscn").instance()
		tooltip.conf(DataLoader.item_db.get(aactor.get(ttype).get(sslot).item).NAME)
#		tooltip.item_name = DataLoader.item_db.get(aactor.get(ttype).get(sslot).item).NAME
	#	tooltip.item_description = item_description
	#	tooltip.item_stats = item_stats
		return tooltip
		
