extends MarginContainer

enum {COMBAT, MANAGMENT, SHOPPING, CRAFTING}
var mode

# COMBAT LAYER PANELS
onready var resources := $CombatLayer/VBoxContainer/Resources
onready var debug := $CombatLayer/VBoxContainer/Debug
onready var compass := $CombatLayer/Compass

# MANAGMENT LAYER PANELS
onready var equipment := $ManagementLayer/MarginContainer/VBoxContainer/ItemSection/HBoxContainer/Equipment
onready var inventory := $ManagementLayer/MarginContainer/VBoxContainer/ItemSection/HBoxContainer/Inventory

onready var item_section := $ManagementLayer/MarginContainer/VBoxContainer/ItemSection
onready var ability_section := $ManagementLayer/MarginContainer/VBoxContainer/AbilitySection
# CRAFTING LAYER PANELS
# SHOPPING LAYER PANELS


func _unhandled_key_input(_event: InputEventKey) -> void:
	if Input.is_action_just_pressed("ui_layer"):
		switch_mode()


func switch_mode():
	if mode == COMBAT:
		set_mode(MANAGMENT)
	else:
		set_mode(COMBAT)


func set_mode(_mode):
	match _mode:
		COMBAT:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			$CombatLayer.show()
			$ManagementLayer.hide()
			$ShoppingLayer.hide()
			$CraftingLayer.hide()
		MANAGMENT:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$CombatLayer.hide()
			$ManagementLayer.show()
			$ShoppingLayer.hide()
			$CraftingLayer.hide()
		SHOPPING:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$CombatLayer.hide()
			$ManagementLayer.hide()
			$ShoppingLayer.show()
			$CraftingLayer.hide()
		CRAFTING:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$CombatLayer.hide()
			$ManagementLayer.hide()
			$ShoppingLayer.hide()
			$CraftingLayer.show()
						
	mode = _mode


func _ready() -> void:
	set_mode(COMBAT)
	connect_signals()
	item_section.show()
	ability_section.hide()


func connect_signals():
	Server.connect("update_equipment_ui", self, "update_equipment_panel")
	Server.connect("update_inventory_ui", self, "update_inventory_panel")
	Server.connect("update_currency_ui", self, "update_currency_panel")


func update_equipment_panel(_data : Dictionary):
	equipment.configure(_data)


func update_inventory_panel(_data : Array):
	inventory.configure(_data)


func update_currency_panel(_data : Dictionary):
	inventory.configure_g(_data)


func _physics_process(_delta: float) -> void: # DEBUG
	debug.conf(Server.latency)


func _on_AbilityButton_pressed() -> void:
	item_section.hide()
	ability_section.show()


func _on_ItemButton_pressed() -> void:
	ability_section.hide()
	item_section.show()
