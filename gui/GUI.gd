extends CanvasLayer

# TOP LAYER
onready var quantity_panel = $MarginContainer/QuantityPanel
onready var loot_panel = $MarginContainer/LootPanel
onready var casting_bar = $MarginContainer/CastingBar
# MIDDLE LAYER
onready var map = $Map
# BOTTOM LAYER
onready var resource_panel = $VBoxContainer/Bottom/VBoxContainer/ResourcePanel
onready var target_resource_panel = $VBoxContainer/HBoxContainer/TargetResourcePanel
onready var minimap_panel = $VBoxContainer/Bottom/MiniMap
onready var skill_panel = $VBoxContainer/Center/Left/SkillPanel
onready var inventory_panel = $VBoxContainer/Center/Right/Inventory
onready var equipment_panel = $VBoxContainer/Center/Center/Equipment
onready var quickbar_panel = $VBoxContainer/Bottom/VBoxContainer/Quickbar
onready var experience_bar = $VBoxContainer/ExperienceBar
onready var chat_box = $VBoxContainer/Bottom/ChatBox
# ELSE
onready var minimap_camera = $VBoxContainer/Bottom/MiniMap/ViewportContainer/Viewport/MiniMapCamera


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("map"):
		if map.visible == false:
			map.show()
		else:
			map.hide()
	if Input.is_action_just_pressed("inventory"):
		if inventory_panel.visible == false:
			inventory_panel.show()
		else:
			inventory_panel.hide()
	if Input.is_action_just_pressed("character"):
		if equipment_panel.visible == false:
			equipment_panel.show()
		else:
			equipment_panel.hide()
	if Input.is_action_just_pressed("skills"):
		if skill_panel.visible == false:
			skill_panel.show()
		else:
			skill_panel.hide()

func conf(resources, minimap_camera_remote_transform):
	resource_panel.health_bar.conf(resources.health.maximum, resources.health.current, Color.red)
	resource_panel.mana_bar.conf(resources.mana.maximum, resources.mana.current, Color.blue)
	resource_panel.stamina_bar.conf(resources.stamina.maximum, resources.stamina.current, Color.orange)
			
	minimap_camera_remote_transform.remote_path = minimap_camera.get_path()
	
func update_gui(res):
	resource_panel.health_bar.updt(res.health.current, res.health.maximum)
	resource_panel.mana_bar.updt(res.mana.current, res.mana.maximum)
	resource_panel.stamina_bar.updt(res.stamina.current, res.stamina.maximum)
	
func configure_target_resources(target):
	target_resource_panel.conf(target)
	
func configure_casting_bar(time):
	 casting_bar.conf(time)
	
func configure_inv(actor):
	inventory_panel.conf(actor, quantity_panel)
	
func configure_eq(actor):
	equipment_panel.conf(actor, quantity_panel)
	
func configure_quickbar(actor):
	quickbar_panel.conf(actor, quantity_panel)

func configure_spellbook(actor):
	skill_panel.conf(actor)
