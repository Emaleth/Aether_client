extends Button

var aactor
var ttype
var sslot
var cooldown = 0

onready var quantity_label = $MarginContainer/Label
onready var timer = $Timer
onready var cd_progress = $TextureProgress
onready var tween = $Tween
onready var timer_label = $TimerLabel

signal request_swap
signal request_use
signal request_quantity

var preview = preload("res://src/gui/drag/DragPreview.tscn")

	
func conf(actor, slot, type, quantity_panel, empty_icon = null):
	aactor = actor
	ttype = type
	sslot = slot
	if not is_connected("request_swap", actor, "move_item"):
		connect("request_swap", actor, "move_item")
	if not is_connected("request_quantity", quantity_panel, "conf"):
		connect("request_quantity", quantity_panel, "conf")
	if actor.get(type).get(slot).item:
		if DataLoader.item_db.get(actor.get(type).get(slot).item).USABLE == true:
			if not actor.is_connected("start_cooldown", self, "cooldown_animation"):
				actor.connect("start_cooldown", self, "cooldown_animation")
			if not is_connected("request_use", actor, "use_item"):
				connect("request_use", actor, "use_item")
		else:
			if is_connected("request_use", actor, "use_item"):
				disconnect("request_use", actor, "use_item")
			if actor.is_connected("start_cooldown", self, "cooldown_animation"):
				actor.disconnect("start_cooldown", self, "cooldown_animation")
				
		icon = load("res://previews/%s.png" % actor.get(type).get(slot).item)
		$MarginContainer2/Ghost.hide()
		hint_tooltip = "wierd fuckery"
		if actor.get(type).get(slot).quantity > 1:
			quantity_label.text = str(actor.get(type).get(slot).quantity)
		else:
			quantity_label.text = ""
	else:
		if is_connected("request_use", actor, "use_item"):
			disconnect("request_use", actor, "use_item")
		if actor.is_connected("start_cooldown", self, "cooldown_animation"):
			actor.disconnect("start_cooldown", self, "cooldown_animation")
		if empty_icon:
			$MarginContainer2/Ghost.texture = empty_icon
			$MarginContainer2/Ghost.self_modulate = Global.item_ghost
			$MarginContainer2/Ghost.show()
			icon = null
		else:
			icon = null
		hint_tooltip = ""
		quantity_label.text = ""
		
func get_drag_data(_position: Vector2):
	if aactor.get(ttype).get(sslot).item && cooldown == 0:
		var my_data = [aactor, ttype, sslot]
		make_preview()
		return my_data

func can_drop_data(_position: Vector2, _data) -> bool:
	return true

func drop_data(_position: Vector2, data) -> void:
	if cooldown == 0:
		var source = data
		var target = [aactor, ttype, sslot]
		if Input.is_action_pressed("split"):
			emit_signal("request_quantity", self, source, target)
		else:
			emit_signal("request_swap", source, target)

func _on_Slot_pressed() -> void: 
	if cooldown == 0 && aactor.get(ttype).get(sslot).item:
		if DataLoader.item_db.get(aactor.get(ttype).get(sslot).item).USABLE == true:
			var source = [aactor, ttype, sslot]
			emit_signal("request_use", source)

func make_preview():
	var pw = preview.instance()
	pw.conf(icon)
	set_drag_preview(pw)

func _make_custom_tooltip(_for_text):
	if aactor.get(ttype).get(sslot).item:
		var tooltip = preload("res://src/gui/tooltip/Tooltip.tscn").instance()
		tooltip.conf(DataLoader.item_db.get(aactor.get(ttype).get(sslot).item).NAME)
		return tooltip
		
func cooldown_animation(cd_item):#, time):
	if DataLoader.item_db.get(aactor.get(ttype).get(sslot).item).USABLE == true:
		if aactor.get(ttype).get(sslot).item == cd_item:
			cooldown = float(DataLoader.item_db.get(aactor.get(ttype).get(sslot).item).CD)
		else:
			if cooldown < Global.cd:
				cooldown = Global.cd
			else:
				return
			
		cd_progress.show()
		timer_label.show()
		cd_progress.value = 100
		tween.remove_all()
		tween.interpolate_property(
			cd_progress, 
			"value", 
			100, 
			0, 
			cooldown, 
			Tween.TRANS_LINEAR, 
			Tween.EASE_IN
			)
		tween.interpolate_property(
			self, 
			"cooldown", 
			cooldown, 
			0, 
			cooldown, 
			Tween.TRANS_LINEAR, 
			Tween.EASE_IN
			)
		tween.start()
		yield(tween, "tween_all_completed")
		cd_progress.hide()
		timer_label.hide()

func _on_Tween_tween_step(_object: Object, _key: NodePath, _elapsed: float, _value: Object) -> void:
	var cd = stepify(cooldown, 0.1)
	timer_label.text = str(cd)

func split(panel, source, target, q):
	emit_signal("request_swap", source, target, q)
	panel.disconnect("send_quantity", self, "split")
	
