extends Button

var ability = null
var cooldown := 0.0
var index : int

onready var shortcut_label := $GridContainer/ShortcutLabel
onready var cooldown_progress := $TextureProgress
onready var cooldown_tween := $TextureProgress/Tween
onready var cooldown_label := $CooldownLabel


func configure(_ability, _index, _shortcut):
	ability = _ability
	index = _index
	config_shortcut(_shortcut)
	set_shortcut_label()
	set_dummy_tooltip_text()
	set_ability_icon()
	set_cooldown()
	
	
func set_dummy_tooltip_text():
	hint_tooltip = "text" if ability else ""
	

func config_shortcut(_shortcut):
	var new_sc := ShortCut.new()
	var new_ia = InputEventAction.new()
	new_ia.action = _shortcut
	new_sc.shortcut = new_ia
	set_shortcut(new_sc)
	
	
func set_cooldown():
	if ability == null: 
		cooldown_progress.hide()
		cooldown_label.hide()
		return 
	var current_time = Server.client_clock
	var ability_data = GlobalVariables.get_ability_data(ability["ability"])
	cooldown = (float(ability_data[1]["cooldown"]) * 1000) - (current_time - ability["last_used"])
	if cooldown > 0:
		cooldown_tween.remove_all()
		cooldown_tween.interpolate_property(
				cooldown_progress,
				"value",
				100,
				0,
				cooldown / 1000.0,
				Tween.TRANS_LINEAR, 
				Tween.EASE_IN)
		cooldown_tween.interpolate_property(
				self,
				"cooldown",
				cooldown,
				0,
				cooldown / 1000.0,
				Tween.TRANS_LINEAR, 
				Tween.EASE_IN)
		cooldown_tween.start()
		cooldown_progress.show()
		cooldown_label.show()

	else:
		cooldown_label.hide()
		cooldown_progress.hide()
		
		
func set_ability_icon() -> void:
	if ability:
		var ability_icon_path = "res://assets/icons/abilities/%s.svg" % str(ability["ability"])
		icon = load(ability_icon_path) if ResourceLoader.exists(ability_icon_path) else preload("res://assets/icons/no_icon.svg")
	else:
		icon = null


func set_shortcut_label() -> void:
	if shortcut:
		shortcut_label.text = InputMap.get_action_list(shortcut.shortcut.action)[0].as_text()
	else:
		shortcut_label.text = ""

				
func _on_Tween_tween_step(_object: Object, _key: NodePath, _elapsed: float, _value: Object) -> void:
	cooldown_label.text = str(round(cooldown))


func _on_Tween_tween_all_completed() -> void:
	cooldown_progress.hide()
	cooldown_label.hide()


func _on_ActionSlot_pressed() -> void:
	Server.request_ability_use(GlobalVariables.player_actor.get_node("gun").global_transform, index)

