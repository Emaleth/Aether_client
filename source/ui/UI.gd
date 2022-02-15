extends MarginContainer

enum {COMBAT, MANAGMENT, SHOP}
var mode

# COMBAT LAYER PANELS
onready var resources := $Combat/VBoxContainer/Resources
onready var debug := $Combat/VBoxContainer/Debug
onready var compass := $Combat/Compass
#onready var spellbook := $Combat/VBoxContainer3/AbilityBar


# MANAGMENT LAYER PANELS
#onready var equipment := $Equip
onready var inventory := $Management/MarginContainer/HBoxContainer/VBoxContainerRight/Inventory
#onready var spellbook := $Management/MarginContainer/HBoxContainer/VBoxContainerLeft/AbilityBar
#
## SHOP LAYER PANELS
#onready var SL_shop := $Shop/CenterContainer2/HBoxContainer/BuySection/Shop
#onready var SL_inventory := $Shop/CenterContainer2/HBoxContainer/SellSection/Inventory
#onready var SL_amount_popup := $Shop/CenterContainer/AmountPopup


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
			$Combat.show()
			$Management.hide()
			$Shop.hide()
		MANAGMENT:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$Combat.hide()
			$Management.show()
			$Shop.hide()
		SHOP:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$Combat.hide()
			$Management.hide()
			$Shop.show()
#			update_shop_ui(GlobalVariables.interactable.goods)
			
	mode = _mode


func _ready() -> void:
	set_mode(COMBAT)
	connect_signals()


func connect_signals():
#	Server.connect("update_equipment_ui", self, "update_equipment_ui")
	Server.connect("update_inventory_ui", self, "update_inventory_ui")
	Server.connect("update_currency_ui", self, "update_currency_ui")
#	Server.connect("update_spellbook_ui", self, "update_spellbook_ui")


#func update_equipment_ui(_data : Dictionary):
#	equipment.configure(_data)


#func update_shop_ui(_data : Array):
#	shop.configure_buy(_data)


func update_inventory_ui(_data : Array):
	inventory.configure(_data)


func update_currency_ui(_data : Dictionary):
	inventory.configure_g(_data)

#func update_spellbook_ui(_data : Array):
#	spellbook.configure(_data)


func _physics_process(_delta: float) -> void:
	debug.conf(Server.latency)
