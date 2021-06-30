extends Button

var data_contaier
var slot_index

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

func conf(_data_container, _slot_index, quantity_panel = null):
	data_contaier = _data_container
	slot_index = _slot_index
#	if not is_connected("request_swap", actor, "move_item"):
#		connect("request_swap", actor, "move_item")
#	if not is_connected("request_split", actor, "split_item"):
#		connect("request_split", actor, "split_item")
#	if quantity_panel:
#		if not is_connected("request_quantity", quantity_panel, "conf"):
#			connect("request_quantity", quantity_panel, "conf")
	if data_contaier.get(slot_index).item:
		if "ITEM" in data_contaier.get(slot_index).item:
			set_item_rarity_bg(data_contaier.get(slot_index).item)
			if DB.item_db.get(data_contaier.get(slot_index).item).SKILL:
				disabled = false
#				if not is_connected("request_use", actor, "use_item"):
#					connect("request_use", actor, "use_item")
				cooldown_animation(
					true, 
					DB.spell_db.get(DB.item_db.get(data_contaier.get(slot_index).item).SKILL).PARAMS.COOLDOWN,
					data_contaier.get(slot_index).use_time
					)
			else:
				disabled = true
#				if is_connected("request_use", actor, "use_item"):
#					disconnect("request_use", actor, "use_item")
				cooldown_animation(false)
				
			item_icon.texture = load("res://textures/item_icons/%s.png" % data_contaier.get(slot_index).item)
				
		elif "SPELL" in data_contaier.get(slot_index).item:
			set_skill_type_bg(data_contaier.get(slot_index).item)
			disabled = false
#			if not is_connected("request_use", actor, "use_spell"):
#				connect("request_use", actor, "use_spell")
			cooldown_animation(
				true, 
				DB.spell_db.get(data_contaier.get(slot_index).item).PARAMS.COOLDOWN,
				data_contaier.get(slot_index).use_time
				)
				
			item_icon.texture = load("res://textures/spell_icons/%s.png" % data_contaier.get(slot_index).item)
		
		item_icon.self_modulate = Color.white
		hint_tooltip = "wierd fuckery"
		if data_contaier.get(slot_index).quantity > 1:
			quantity_label.text = str(data_contaier.get(slot_index).quantity)
		else:
			quantity_label.text = ""
	else:
		cooldown_animation(false)
#		if is_connected("request_use", actor, "use_item"):
#			disconnect("request_use", actor, "use_item")
		item_icon.texture = ghost_image
		item_icon.self_modulate = Global.item_ghost
		hint_tooltip = ""
		quantity_label.text = ""
		
func get_drag_data(_position: Vector2):
	if data_contaier.get(slot_index).item:
		var my_data = [data_contaier, slot_index]
		make_preview()
		return my_data

func can_drop_data(_position: Vector2, _data) -> bool:
	return true

func drop_data(_position: Vector2, data) -> void:
	var source = data
	var target = [data_contaier, slot_index]
	if Input.is_action_pressed("split") && source[0].get(source[1]).quantity > 1:
		emit_signal("request_quantity", self, source, target)
	else:
		emit_signal("request_swap", source, target)

func _on_Slot_pressed() -> void: 
	var source = [data_contaier, slot_index]
	emit_signal("request_use", source)

func make_preview():
	var pw = preview.instance()
	pw.conf(item_icon.texture)
	set_drag_preview(pw)

func _make_custom_tooltip(_for_text):
	if data_contaier.get(slot_index).item:
		var tooltip = null
		if "ITEM" in data_contaier.get(slot_index).item:
			tooltip = preload("res://gui/item_tooltip/ItemTooltip.tscn").instance()
			var item_name : String = ""
			var item_description : String = ""
			var item_stats : Dictionary = {}
			var item_attributes : Dictionary = {}
			var item_rarity : String = ""
			var item_skill : Dictionary = {}
			make_item_ttp(tooltip, item_name, item_description, item_stats, item_attributes, item_rarity, item_skill)
		elif "SPELL" in data_contaier.get(slot_index).item:
			tooltip = preload("res://gui/skill_tooltip/SkillTooltip.tscn").instance()
			var skill_name : String = ""
			var skill_description : String = ""
			var skill_cost : Dictionary = {}
			var skill_params : Dictionary = {}
			var skill_target : Dictionary = {}
			make_spell_ttp(tooltip, skill_name, skill_description, skill_cost, skill_params, skill_target)
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
#				if cd_now < (global_cd - (current_time - aactor.gcd_used)):
#					if current_time - aactor.gcd_used < global_cd:
#						cd_from = global_cd
#						cd_now = (global_cd - (current_time - aactor.gcd_used))
#		elif current_time - aactor.gcd_used < global_cd:
#			cd_from = global_cd
#			cd_now = (global_cd - (current_time - aactor.gcd_used))
		
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
	
func make_item_ttp(tooltip, item_name, item_description, item_stats, item_attributes, item_rarity, item_skill):
	if DB.item_db.get(data_contaier.get(slot_index).item).NAME:
		item_name = DB.item_db.get(data_contaier.get(slot_index).item).NAME
	if DB.item_db.get(data_contaier.get(slot_index).item).SKILL:
		item_description = "item description"
	if DB.item_db.get(data_contaier.get(slot_index).item).STATS:
		item_stats = DB.item_db.get(data_contaier.get(slot_index).item).STATS
	if DB.item_db.get(data_contaier.get(slot_index).item).ATTRIBUTES:
		item_attributes = DB.item_db.get(data_contaier.get(slot_index).item).ATTRIBUTES
	if DB.item_db.get(data_contaier.get(slot_index).item).RARITY:
		item_rarity = DB.item_db.get(data_contaier.get(slot_index).item).RARITY
	if DB.item_db.get(data_contaier.get(slot_index).item).SKILL:
		item_skill["skill_name"] = DB.spell_db.get(DB.item_db.get(data_contaier.get(slot_index).item).SKILL).NAME
		item_skill["skill_description"] = "skill description"
		item_skill["skill_cost"] = DB.spell_db.get(DB.item_db.get(data_contaier.get(slot_index).item).SKILL).COST
		item_skill["skill_params"] = DB.spell_db.get(DB.item_db.get(data_contaier.get(slot_index).item).SKILL).PARAMS
		item_skill["skill_target"] = DB.spell_db.get(DB.item_db.get(data_contaier.get(slot_index).item).SKILL).TARGET
	tooltip.conf(item_name, item_description, item_stats, item_attributes, item_rarity, item_skill)
	
func make_spell_ttp(tooltip, skill_name, skill_cost, skill_description, skill_params, skill_target):
	if DB.spell_db.get(data_contaier.get(slot_index).item).NAME:
		skill_name = DB.spell_db.get(data_contaier.get(slot_index).item).NAME
	skill_description = "dsgfksdfhgkjhds"
	if DB.spell_db.get(data_contaier.get(slot_index).item).COST:
		skill_cost = DB.spell_db.get(data_contaier.get(slot_index).item).COST
	if DB.spell_db.get(data_contaier.get(slot_index).item).PARAMS:
		skill_params = DB.spell_db.get(data_contaier.get(slot_index).item).PARAMS
	if DB.spell_db.get(data_contaier.get(slot_index).item).TARGET:
		skill_target = DB.spell_db.get(data_contaier.get(slot_index).item).TARGET
	tooltip.conf(skill_name, skill_description, skill_cost, skill_params, skill_target)

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
