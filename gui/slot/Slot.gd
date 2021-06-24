extends Button

var aactor
var ttype
var sslot

var ghost_image = null
var preview = preload("res://gui/drag_preview/DragPreview.tscn")

onready var quantity_label = $Margin/Label
onready var timer = $Timer
onready var cd_progress = $TextureProgress
onready var tween = $Tween
onready var timer_label = $TimerLabel
onready var item_icon_margin = $Margin
onready var item_icon = $Margin/Icon

onready var common_item_slot = preload("res://styleboxes/common_item_slot.tres")
onready var uncommon_item_slot = preload("res://styleboxes/uncommon_item_slot.tres")
onready var rare_item_slot = preload("res://styleboxes/rare_item_slot.tres")
onready var epic_item_slot = preload("res://styleboxes/epic_item_slot.tres")
onready var legendary_item_slot = preload("res://styleboxes/legendary_item_slot.tres")

onready var healing_target_skill_slot = preload("res://styleboxes/healing_target_skill_slot.tres")
onready var healing_aoe_skill_slot = preload("res://styleboxes/healing_aoe_skill_slot.tres")
onready var damage_target_skill_slot = preload("res://styleboxes/damage_target_skill_slot.tres")
onready var damage_aoe_skill_slot = preload("res://styleboxes/damage_aoe_skill_slot.tres")

signal request_swap
signal request_use
signal request_quantity
signal request_split


func _ready() -> void:
	ghost_image = icon
	icon = null

func conf(actor, slot, type, quantity_panel = null):
	aactor = actor
	ttype = type
	sslot = slot
	if not is_connected("request_swap", actor, "move_item"):
		connect("request_swap", actor, "move_item")
	if not is_connected("request_split", actor, "split_item"):
		connect("request_split", actor, "split_item")
	if quantity_panel:
		if not is_connected("request_quantity", quantity_panel, "conf"):
			connect("request_quantity", quantity_panel, "conf")
	if actor.get(type).get(slot).item:
		if "ITEM" in actor.get(type).get(slot).item:
			set_item_rarity_bg(actor.get(type).get(slot).item)
			if DB.item_db.get(actor.get(type).get(slot).item).SKILL:
				disabled = false
				if not is_connected("request_use", actor, "use_item"):
					connect("request_use", actor, "use_item")
				cooldown_animation(
					true, 
					DB.spell_db.get(DB.item_db.get(actor.get(type).get(slot).item).SKILL).COOLDOWN,
					actor.get(type).get(slot).use_time
					)
			else:
				disabled = true
				if is_connected("request_use", actor, "use_item"):
					disconnect("request_use", actor, "use_item")
				cooldown_animation(false)
				
			item_icon.texture = load("res://textures/item_icons/%s.png" % actor.get(type).get(slot).item)
				
		elif "SPELL" in actor.get(type).get(slot).item:
			set_skill_type_bg(actor.get(type).get(slot).item)
			disabled = false
			if not is_connected("request_use", actor, "use_spell"):
				connect("request_use", actor, "use_spell")
			cooldown_animation(
				true, 
				DB.spell_db.get(actor.get(type).get(slot).item).COOLDOWN,
				actor.get(type).get(slot).use_time
				)
				
			item_icon.texture = load("res://textures/spell_icons/%s.png" % actor.get(type).get(slot).item)
		
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
	var source = [aactor, ttype, sslot]
	emit_signal("request_use", source)

func make_preview():
	var pw = preview.instance()
	pw.conf(item_icon.texture)
	set_drag_preview(pw)

func _make_custom_tooltip(_for_text):
	if aactor.get(ttype).get(sslot).item:
		var tooltip = preload("res://gui/tooltip/Tooltip.tscn").instance()
		var n = ""
		var i = null
		var d = ""
		var s = {}
		var a = {}
		var r = null
		if "ITEM" in aactor.get(ttype).get(sslot).item:
			make_item_ttp(tooltip, n, i, d, s, a, r)
		elif "SPELL" in aactor.get(ttype).get(sslot).item:
			make_spell_ttp(tooltip, n, i, d, s, a, r)
		return tooltip
		
var cd_text = 0
func cooldown_animation(animate : bool, cd = null, last_cd = 0):
	if animate == true:
		var current_time = OS.get_ticks_msec()
		var cd_from = 0
		var cd_now = 0
		var global_cd = Global.cd * 1000
		last_cd = float(last_cd)
		if cd != null:
			cd = (float(cd) * 1000)
		else:
			cd = 0.0
		if current_time - last_cd < cd && last_cd != 0:
				cd_from = cd
				cd_now = (cd - (current_time - last_cd))
				if cd_now < (global_cd - (current_time - aactor.gcd_used)):
					if current_time - aactor.gcd_used < global_cd:
						cd_from = global_cd
						cd_now = (global_cd - (current_time - aactor.gcd_used))
		elif current_time - aactor.gcd_used < global_cd:
			cd_from = global_cd
			cd_now = (global_cd - (current_time - aactor.gcd_used))
		
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
	
func make_item_ttp(tooltip, item_name, skill_image, item_description, item_stats, item_attributes, item_rarity):
	if DB.item_db.get(aactor.get(ttype).get(sslot).item).SKILL:
		skill_image = load("res://textures/spell_icons/%s.png" % DB.item_db.get(aactor.get(ttype).get(sslot).item).SKILL)
	if DB.item_db.get(aactor.get(ttype).get(sslot).item).NAME:
		item_name = DB.item_db.get(aactor.get(ttype).get(sslot).item).NAME
	if DB.item_db.get(aactor.get(ttype).get(sslot).item).SKILL:
		item_description = DB.spell_db.get(DB.item_db.get(aactor.get(ttype).get(sslot).item).SKILL).NAME
	if DB.item_db.get(aactor.get(ttype).get(sslot).item).STATS:
		item_stats = DB.item_db.get(aactor.get(ttype).get(sslot).item).STATS
	if DB.item_db.get(aactor.get(ttype).get(sslot).item).ATTRIBUTES:
		item_attributes = DB.item_db.get(aactor.get(ttype).get(sslot).item).ATTRIBUTES
	item_rarity = DB.item_db.get(aactor.get(ttype).get(sslot).item).RARITY
	tooltip.conf(item_name, skill_image, item_description, item_stats, item_attributes, item_rarity)
	
func make_spell_ttp(tooltip, skill_name, skill_image, skill_description, skill_stats, skill_attributes, skill_type):
	if DB.spell_db.get(aactor.get(ttype).get(sslot).item).NAME:
		skill_name = DB.spell_db.get(aactor.get(ttype).get(sslot).item).NAME
	tooltip.conf(skill_name, skill_image, skill_description, skill_stats, skill_attributes, skill_type)

func set_item_rarity_bg(item):
	match DB.item_db.get(item).RARITY:
		"COMMON":
			set("custom_styles/hover", common_item_slot)
			set("custom_styles/pressed", common_item_slot)
			set("custom_styles/focus", common_item_slot)
			set("custom_styles/disabled", common_item_slot)
			set("custom_styles/normal", common_item_slot)
		"UNCOMMON":
			set("custom_styles/hover", uncommon_item_slot)
			set("custom_styles/pressed", uncommon_item_slot)
			set("custom_styles/focus", uncommon_item_slot)
			set("custom_styles/disabled", uncommon_item_slot)
			set("custom_styles/normal", uncommon_item_slot)
		"RARE":
			set("custom_styles/hover", rare_item_slot)
			set("custom_styles/pressed", rare_item_slot)
			set("custom_styles/focus", rare_item_slot)
			set("custom_styles/disabled", rare_item_slot)
			set("custom_styles/normal", rare_item_slot)
		"EPIC":
			set("custom_styles/hover", epic_item_slot)
			set("custom_styles/pressed", epic_item_slot)
			set("custom_styles/focus", epic_item_slot)
			set("custom_styles/disabled", epic_item_slot)
			set("custom_styles/normal", epic_item_slot)
		"LEGENDARY":
			set("custom_styles/hover", legendary_item_slot)
			set("custom_styles/pressed", legendary_item_slot)
			set("custom_styles/focus", legendary_item_slot)
			set("custom_styles/disabled", legendary_item_slot)
			set("custom_styles/normal", legendary_item_slot)
			
func set_skill_type_bg(skill):
	match DB.spell_db.get(skill).TYPE:
		"AOE":
			set("custom_styles/hover", common_item_slot)
			set("custom_styles/pressed", common_item_slot)
			set("custom_styles/focus", common_item_slot)
			set("custom_styles/disabled", common_item_slot)
			set("custom_styles/normal", common_item_slot)
		"TARGET":
			set("custom_styles/hover", legendary_item_slot)
			set("custom_styles/pressed", legendary_item_slot)
			set("custom_styles/focus", legendary_item_slot)
			set("custom_styles/disabled", legendary_item_slot)
			set("custom_styles/normal", legendary_item_slot)
