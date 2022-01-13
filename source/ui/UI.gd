extends MarginContainer

enum {COMBAT, MANAGMENT, SHOP}
var mode

# COMBAT LAYER PANELS
onready var CL_resources := $Combat/VBoxContainer/Resources
onready var CL_debug := $Combat/VBoxContainer/Debug
onready var CL_compass := $Combat/Compass
onready var CL_spellbook := $Combat/VBoxContainer3/AbilityBar
onready var CL_pouch := $Combat/VBoxContainer3/Pouch

# MANAGMENT LAYER PANELS
onready var ML_equipment := $Management/MarginContainer/HBoxContainer/VBoxContainerLeft/Equipment
onready var ML_inventory := $Management/MarginContainer/HBoxContainer/VBoxContainerRight/Inventory
onready var ML_spellbook := $Management/MarginContainer/HBoxContainer/VBoxContainerLeft/AbilityBar
onready var ML_pouch := $Management/MarginContainer/HBoxContainer/VBoxContainerRight/Pouch
onready var ML_amount_popup := $Management/CenterContainer/AmountPopup

# SHOP LAYER PANELS
onready var SL_inventory := $Shop/HBoxContainer/Inventory
onready var SL_shop := $Shop/HBoxContainer/Shop
onready var SL_amount_popup := $Shop/CenterContainer/AmountPopup


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
	mode = _mode


func _ready() -> void:
	set_mode(COMBAT)
	connect_signals()
	
	
func connect_signals():
	Server.connect("update_equipment_ui", self, "update_equipment_ui")
	Server.connect("update_inventory_ui", self, "update_inventory_ui")
	Server.connect("update_pouch_ui", self, "update_pouch_ui")
	Server.connect("update_spellbook_ui", self, "update_spellbook_ui")

	
func update_equipment_ui(_data : Dictionary):
	ML_equipment.configure(_data)
	
	
func update_inventory_ui(_data : Array):
	ML_inventory.configure(_data)
	SL_inventory.configure(_data)


func update_pouch_ui(_data : Array):
	CL_pouch.configure(_data)
	ML_pouch.configure(_data)


func update_spellbook_ui(_data : Array):
	CL_spellbook.configure(_data)
	ML_spellbook.configure(_data)

	
func _physics_process(_delta: float) -> void:
	CL_debug.conf(Server.latency)
