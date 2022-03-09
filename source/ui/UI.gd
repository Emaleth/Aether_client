extends MarginContainer

enum {COMBAT, MANAGMENT, SHOPPING, CRAFTING, LOOTING}
var mode

# COMBAT LAYER PANELS
onready var resources_panel := $CombatLayer/VBoxContainer/Resources
onready var debug := $CombatLayer/VBoxContainer/Debug
onready var compass := $CombatLayer/Compass

# MANAGMENT LAYER PANELS
onready var equipment_panel := $ManagementLayer/MarginContainer/VBoxContainer/ItemSection/HBoxContainer/VBoxContainer/Equipment
onready var attributes_panel := $ManagementLayer/MarginContainer/VBoxContainer/ItemSection/HBoxContainer/VBoxContainer/AttributesPanel
onready var inventory_panel := $ManagementLayer/MarginContainer/VBoxContainer/ItemSection/HBoxContainer/VBoxContainer2/Inventory
onready var currency_panel := $ManagementLayer/MarginContainer/VBoxContainer/ItemSection/HBoxContainer/VBoxContainer2/CurrencyPanel

onready var item_section := $ManagementLayer/MarginContainer/VBoxContainer/ItemSection
onready var ability_panel := $ManagementLayer/MarginContainer/VBoxContainer/AbilitiesPanel

# CRAFTING LAYER PANELS
onready var crafting_panel := $CraftingLayer/CenterContainer/CraftingPanel

# SHOPPING LAYER PANELS
onready var shopping_panel := $ShoppingLayer/Shop
# LOOTING LAYER PANELS
onready var looting_panel := $LootingLayer/CenterContainer/LootingPanel


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
			$LootingLayer.hide()
		MANAGMENT:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$CombatLayer.hide()
			$ManagementLayer.show()
			$ShoppingLayer.hide()
			$CraftingLayer.hide()
			$LootingLayer.hide()
		SHOPPING:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$CombatLayer.hide()
			$ManagementLayer.hide()
			$ShoppingLayer.show()
			$CraftingLayer.hide()
			$LootingLayer.hide()
		CRAFTING:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$CombatLayer.hide()
			$ManagementLayer.hide()
			$ShoppingLayer.hide()
			$CraftingLayer.show()
			$LootingLayer.hide()
		LOOTING:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$CombatLayer.hide()
			$ManagementLayer.hide()
			$ShoppingLayer.hide()
			$CraftingLayer.hide()
			$LootingLayer.show()
						
	mode = _mode


func _ready() -> void:
	set_mode(COMBAT)
	connect_signals()
	item_section.show()
	ability_panel.hide()


func connect_signals():
	Server.connect("update_equipment_ui", self, "update_equipment_panel")
	Server.connect("sig_update_attributes", self, "update_attributes_panel")
	Server.connect("update_inventory_ui", self, "update_inventory_panel")
	Server.connect("sig_update_currency", self, "update_currency_panel")
	Server.connect("update_ability_ui", self, "update_ability_panel")
	Server.connect("update_crafting_ui", self, "update_crafting_panel")


func update_equipment_panel(_data : Dictionary):
	equipment_panel.configure(_data)


func update_attributes_panel(_data : Dictionary):
	attributes_panel.update_data(_data)


func update_inventory_panel(_data : Array):
	inventory_panel.configure(_data)


func update_crafting_panel(_data : Array):
	crafting_panel.configure(_data)


func update_ability_panel(_data : Array):
	ability_panel.configure(_data)


func update_currency_panel(_data : Dictionary):
	currency_panel.configure_g(_data)


func update_shopping_panel(_data : Array):
	shopping_panel.configure(_data)
	

func _physics_process(_delta: float) -> void: # DEBUG
	debug.conf(Server.latency)


func _on_AbilityButton_pressed() -> void:
	item_section.hide()
	ability_panel.show()


func _on_ItemButton_pressed() -> void:
	ability_panel.hide()
	item_section.show()


func conf_loot(_data, _npc_id):
	looting_panel.configure(_data, int(_npc_id))
	set_mode(LOOTING)

func conf_shop(_data, _shop_id):
	shopping_panel.configure(_data, int(_shop_id))
	set_mode(SHOPPING)
