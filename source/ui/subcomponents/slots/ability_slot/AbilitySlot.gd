extends Button

var ability = null
var index : int

onready var interaction_menu := $InteractionMenu
#onready var tooltip = preload("res://source/ui/tooltip/Tooltip.tscn")


func configure(_ability, _index):
	ability = _ability
	index = _index
	set_dummy_tooltip_text()
	set_ability_icon()
	connect_interaction_menu_signals()
	
	
func connect_interaction_menu_signals():
	interaction_menu.connect("pin", Server, "request_ability_pin", [index])
	
	
func set_dummy_tooltip_text():
	hint_tooltip = "text" if ability else ""
	
	
#func _make_custom_tooltip(_for_text: String) -> Control:
#	var new_tooltip = tooltip.instance()
#	new_tooltip.conf(ability)
#	return new_tooltip
		
		
func set_ability_icon() -> void:
	if ability:
		var ability_icon_path = "res://assets/icons/item//%s.svg" % str(ability["ability"])
		icon = load(ability_icon_path) if ResourceLoader.exists(ability_icon_path) else preload("res://assets/icons/no_icon.svg")
	else:
		icon = null
		
		
func _on_AbilitySlot_pressed() -> void:
	if ability:
		$InteractionMenu.show_menu()

