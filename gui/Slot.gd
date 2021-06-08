extends Button

var aactor
var ttype
var sslot

onready var quantity_label = $Margin/Label
onready var timer = $Timer
onready var cd_progress = $TextureProgress
onready var tween = $Tween
onready var timer_label = $TimerLabel

onready var item_icon_margin = $Margin
onready var item_icon = $Margin/Icon
var ghost_image = null

signal request_swap
signal request_use
signal request_quantity
signal request_split

var preview = preload("res://gui/DragPreview.tscn")

func _ready() -> void:
	ghost_image = icon
	icon = null

func conf(actor, slot, type, quantity_panel):
	aactor = actor
	ttype = type
	sslot = slot
	if not is_connected("request_swap", actor, "move_item"):
		connect("request_swap", actor, "move_item")
	if not is_connected("request_split", actor, "split_item"):
		connect("request_split", actor, "split_item")
	if not is_connected("request_quantity", quantity_panel, "conf"):
		connect("request_quantity", quantity_panel, "conf")
	if actor.get(type).get(slot).item:
		if DB.item_db.get(actor.get(type).get(slot).item).SKILL:
			cooldown_animation(true, (float(DB.spell_db.get(DB.item_db.get(actor.get(type).get(slot).item).SKILL).COOLDOWN) * 1000), actor.get(type).get(slot).use_time)
			if not is_connected("request_use", actor, "use_item"):
				connect("request_use", actor, "use_item")
		else:
			cooldown_animation(false)
			if is_connected("request_use", actor, "use_item"):
				disconnect("request_use", actor, "use_item")
				
		item_icon.texture = load("res://previews/%s.png" % actor.get(type).get(slot).item)
		item_icon.self_modulate = Color.white
		hint_tooltip = "wierd fuckery"
		if actor.get(type).get(slot).quantity > 1:
			quantity_label.text = str(actor.get(type).get(slot).quantity)
		else:
			quantity_label.text = ""
	else:
		cooldown_animation(false)
		if is_connected("request_use", actor, "use_item"):
			disconnect("request_use", actor, "use_item")
		item_icon.texture = ghost_image
		item_icon.self_modulate = Global.item_ghost
		hint_tooltip = ""
		quantity_label.text = ""
		
func get_drag_data(_position: Vector2):
	if aactor.get(ttype).get(sslot).item:
		var my_data = [aactor, ttype, sslot]
		make_preview()
		return my_data

func can_drop_data(_position: Vector2, _data) -> bool:
	return true

func drop_data(_position: Vector2, data) -> void:
	var source = data
	var target = [aactor, ttype, sslot]
	if Input.is_action_pressed("split") && source[0].get(source[1])[source[2]].quantity > 1:
		emit_signal("request_quantity", self, source, target)
	else:
		emit_signal("request_swap", source, target)

func _on_Slot_pressed() -> void: 
	if aactor.get(ttype).get(sslot).item:
		if DB.item_db.get(aactor.get(ttype).get(sslot).item).SKILL:
			var source = [aactor, ttype, sslot]
			emit_signal("request_use", source)

func make_preview():
	var pw = preview.instance()
	pw.conf(item_icon.texture)
	set_drag_preview(pw)

func _make_custom_tooltip(_for_text):
	if aactor.get(ttype).get(sslot).item:
		var tooltip = preload("res://gui/Tooltip.tscn").instance()
		var n = ""
		var d = ""
		var s = {}
		if DB.item_db.get(aactor.get(ttype).get(sslot).item).NAME:
			n = DB.item_db.get(aactor.get(ttype).get(sslot).item).NAME
		if DB.item_db.get(aactor.get(ttype).get(sslot).item).SKILL:
			d = DB.spell_db.get(DB.item_db.get(aactor.get(ttype).get(sslot).item).SKILL).TYPE
		if DB.item_db.get(aactor.get(ttype).get(sslot).item).STR:
			s["strenght"] = str(DB.item_db.get(aactor.get(ttype).get(sslot).item).STR)
		else:
			s["strenght"] = null
		if DB.item_db.get(aactor.get(ttype).get(sslot).item).DEX:
			s["dexterity"] = str(DB.item_db.get(aactor.get(ttype).get(sslot).item).DEX)
		else:
			s["dexterity"] = null
		if DB.item_db.get(aactor.get(ttype).get(sslot).item).CONST:
			s["constitution"] = str(DB.item_db.get(aactor.get(ttype).get(sslot).item).CONST)
		else:
			s["constitution"] = null
		if DB.item_db.get(aactor.get(ttype).get(sslot).item).INT:
			s["intelligence"] = str(DB.item_db.get(aactor.get(ttype).get(sslot).item).INT)
		else:
			s["intelligence"] = null
		if DB.item_db.get(aactor.get(ttype).get(sslot).item).WIS:
			s["wisdome"] = str(DB.item_db.get(aactor.get(ttype).get(sslot).item).WIS)
		else:
			s["wisdome"] = null
		tooltip.conf(n, d, s)
		return tooltip
		
var cd_text = 0
func cooldown_animation(animate : bool, cd : float = 0.0, last_cd : float = 0.0, gcd : float = Global.cd * 1000, last_gcd : float = aactor.gcd_used):
	if animate == true:
		var current_time = OS.get_ticks_msec()
		var cd_from = 0
		var cd_now = 0
		if current_time - last_cd < cd && last_cd != 0:
			cd_from = cd
			cd_now = (cd - (current_time - last_cd))
			if cd_now < (gcd - (current_time - last_gcd)):
				if current_time - last_gcd < gcd:
					cd_from = gcd
					cd_now = (gcd - (current_time - last_gcd))
		elif current_time - last_gcd < gcd:
			cd_from = gcd
			cd_now = (gcd - (current_time - last_gcd))
		
		else:
			tween.stop_all()
			cd_progress.hide()
			timer_label.hide()
			return
			
		cd_progress.max_value = cd_from
		cd_progress.value = cd_now
		cd_text = cd_now / 1000
		cd_progress.show()
		timer_label.show()
		
		tween.remove_all()
		tween.interpolate_property(
			cd_progress, 
			"value", 
			cd_progress.value, 
			0, 
			cd_now / 1000, 
			Tween.TRANS_LINEAR, 
			Tween.EASE_IN
			)
		tween.interpolate_property(
			self, 
			"cd_text", 
			cd_text, 
			0, 
			cd_now / 1000, 
			Tween.TRANS_LINEAR, 
			Tween.EASE_IN
			)
		tween.start()
		yield(tween, "tween_all_completed")
		cd_progress.hide()
		timer_label.hide()
	else:
		tween.stop_all()
		cd_progress.hide()
		timer_label.hide()
		
func _on_Tween_tween_step(_object: Object, _key: NodePath, _elapsed: float, _value: Object) -> void:
	timer_label.text = str(stepify(cd_text, 0.1))

func split(panel, source, target, q):
	emit_signal("request_split", source, target, q)
	panel.disconnect("send_quantity", self, "split")
	
func small():
	rect_min_size = Vector2(20, 20)
	rect_size = Vector2(20, 20)
	item_icon_margin.set("custom_constants/margin_bottom", 0) 
	item_icon_margin.set("custom_constants/margin_left", 0) 
	item_icon_margin.set("custom_constants/margin_right", 0) 
	item_icon_margin.set("custom_constants/margin_top", 0) 
	item_icon.margin_top = 0
	item_icon.margin_left = 0
	item_icon.margin_bottom = 20
	item_icon.margin_right = 20
	quantity_label.margin_top = 0
	quantity_label.margin_left = 0
	quantity_label.margin_bottom = 20
	quantity_label.margin_right = 20
	


