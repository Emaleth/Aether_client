extends CanvasLayer

# TOP-RIGHT
onready var resource_panel = $VBoxContainer/Bottom/VBoxContainer/ResourcePanel
# TOP-CENTER
onready var target_resource_panel = $VBoxContainer/HBoxContainer/TargetResourcePanel
# TOP-LEFT
onready var minimap_panel = $VBoxContainer/Bottom/MiniMap
onready var minimap_camera = $VBoxContainer/Bottom/MiniMap/ViewportContainer/Viewport/MiniMapCamera
# MIDDLE-LEFT
onready var equipment_panel = $VBoxContainer/Center/Center/Equipment
# MIDDLE-CENTER
onready var skill_panel = $VBoxContainer/Center/Left/SkillPanel
# MIDDLE-RIGHT
onready var inventory_panel = $VBoxContainer/Center/Right/Inventory
# BOTTOM-CENTER
onready var quickbar_panel = $VBoxContainer/Bottom/VBoxContainer/Quickbar
# BOTTOM-FULL
onready var experience_bar = $VBoxContainer/ExperienceBar
# FULL 
onready var map = $Map
onready var quantity_panel = $MarginFree/QuantityPanel
onready var loot_panel = $MarginFree/LootPanel
onready var casting_bar = $MarginFree/CastingBar
onready var chat_box = $VBoxContainer/Bottom/ChatBox

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
	
func get_target_info(target, yay_or_nay):
	if yay_or_nay == false:
		target_resource_panel.hide()
	else:
		target_resource_panel.name_label.text = target.statistics.name
		target_resource_panel.name_label.show()
		target_resource_panel.health_bar.conf(target.resources.health.maximum, target.resources.health.current, Color.red)
		target_resource_panel.mana_bar.conf(target.resources.mana.maximum, target.resources.mana.current, Color.blue)
		target_resource_panel.stamina_bar.conf(target.resources.stamina.maximum, target.resources.stamina.current, Color.orange)
		target_resource_panel.show()
	
func update_targe_info(res):
	target_resource_panel.health_bar.updt(res.health.current, res.health.maximum)
	target_resource_panel.mana_bar.updt(res.mana.current, res.mana.maximum)
	target_resource_panel.stamina_bar.updt(res.stamina.current, res.stamina.maximum)

func configure_inv(actor):
	inventory_panel.conf(actor, quantity_panel)
	
func configure_eq(actor):
	equipment_panel.conf(actor, quantity_panel)
	
func configure_quickbar(actor):
	quickbar_panel.conf(actor, quantity_panel)

func configure_spellbook(actor):
	skill_panel.conf(actor)
