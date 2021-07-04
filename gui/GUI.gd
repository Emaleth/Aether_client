extends CanvasLayer

enum {COMBAT, MANAGEMNET, LOOT, SHOP, MAP}
var mode = COMBAT
# TOP LAYER
onready var quantity_panel = $MarginContainer/QuantityPanel
onready var loot_panel = $MarginContainer/LootPanel
onready var casting_bar = $MarginContainer/CastingBar
# MIDDLE LAYER
onready var map = $Map
# BOTTOM LAYER
onready var minimap = $VBoxContainer/Bottom/MiniMap
onready var resource_panel = $VBoxContainer/Bottom/VBoxContainer/ResourcePanel
onready var minimap_panel = $VBoxContainer/Bottom/MiniMap
onready var skill_panel = $VBoxContainer/Center/Left/SkillPanel
onready var inventory_panel = $VBoxContainer/Center/Right/Inventory
onready var character_sheet_panel = $VBoxContainer/Center/Center/Equipment
onready var quickbar_panel = $VBoxContainer/Bottom/VBoxContainer/Quickbar
onready var experience_bar = $VBoxContainer/ExperienceBar
onready var chat_box = $VBoxContainer/Bottom/ChatBox

onready var crosshair = $CenterContainer/Crosshair

func _ready() -> void:
	switch_ui_mode(COMBAT)
	Server.connect("player_resources_returned", self, "configure_resources_panel")
	Server.connect("player_spellbook_returned", self, "configure_spellbook")
	Server.connect("player_quickbar_returned", self, "configure_quickbar")
	Server.connect("player_equipment_returned", self, "configure_eq")
	Server.connect("player_inventory_returned", self, "configure_inv")
	Server.connect("player_attributes_returned", self, "configure_attributes")
	
	Server.fetch_player_inventory()
	Server.fetch_player_equipment()
	Server.fetch_player_spellbook()
	Server.fetch_player_resources()
	Server.fetch_player_quickbar()
	Server.fetch_player_attributes()
	
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_mode"):
		match mode:
			COMBAT:
				switch_ui_mode(MANAGEMNET)
			MANAGEMNET:
				switch_ui_mode(COMBAT)
			LOOT:
				switch_ui_mode(MANAGEMNET) 
			SHOP:
				switch_ui_mode(MANAGEMNET)
			MAP:
				switch_ui_mode(MANAGEMNET)

	if Input.is_action_just_pressed("map"):
		match mode:
			COMBAT:
				switch_ui_mode(MAP)
			MANAGEMNET:
				switch_ui_mode(MAP)
			LOOT:
				switch_ui_mode(MAP) 
			SHOP:
				switch_ui_mode(MAP)
			MAP:
				switch_ui_mode(COMBAT)

func switch_ui_mode(new_mode):
	mode = new_mode
	match mode:
		COMBAT:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			inventory_panel.hide()
			character_sheet_panel.hide()
			skill_panel.hide()
			map.hide()
			crosshair.show()
		MANAGEMNET:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			inventory_panel.show()
			character_sheet_panel.show()
			skill_panel.show()
			map.hide()
			crosshair.hide()
		LOOT:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			pass 
		SHOP:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			pass
		MAP:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			inventory_panel.hide()
			character_sheet_panel.hide()
			skill_panel.hide()
			crosshair.hide()
			map.show()
			
			
func configure_resources_panel(data):
	resource_panel.conf(data)
	
func update_resources_panel(data):
	resource_panel.update_resources(data)
	
func get_minimap_camera_path():
	var cam_path = minimap.camera.get_path()
	return cam_path
	
func configure_casting_bar(time):
	casting_bar.conf(time)
	
func configure_inv(data):
	inventory_panel.conf(data, quantity_panel)
	
func configure_eq(data):
	character_sheet_panel.conf(data, quantity_panel)
	
func configure_attributes(data):
	character_sheet_panel.conf_attributes(data.total, data.points)
#
func configure_quickbar(data):
	quickbar_panel.conf(data)

func configure_spellbook(data):
	skill_panel.conf(data)

