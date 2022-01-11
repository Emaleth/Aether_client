extends MarginContainer

enum {COMBAT, MANAGMENT}
var mode

# COMBAT LAYER PANELS
export(NodePath) var CL_resources_node
onready var CL_resources := get_node(CL_resources_node)


export(NodePath) var CL_debug_node
onready var CL_debug := get_node(CL_debug_node)

export(NodePath) var CL_compass_node
onready var CL_compass := get_node(CL_compass_node)

export(NodePath) var CL_spellbook_node
onready var CL_spellbook := get_node(CL_spellbook_node)

export(NodePath) var CL_pouch_node
onready var CL_pouch := get_node(CL_pouch_node)

# MANAGMENT LAYER PANELS
export(NodePath) var ML_equipment_node
onready var ML_equipment := get_node(ML_equipment_node)

export(NodePath) var ML_inventory_node
onready var ML_inventory := get_node(ML_inventory_node)

export(NodePath) var ML_spellbook_node
onready var ML_spellbook := get_node(ML_spellbook_node)

export(NodePath) var ML_pouch_node
onready var ML_pouch := get_node(ML_pouch_node)

export(NodePath) var ML_amount_popup_node
onready var ML_amount_popup := get_node(ML_amount_popup_node)


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
		MANAGMENT:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$Combat.hide()
			$Management.show()
	mode = _mode


func _ready() -> void:
	set_mode(COMBAT)
	connect_signals()
	
	
func connect_signals():
	Server.connect("update_equipment_ui", self, "update_equipment_ui")
	Server.connect("update_inventory_ui", self, "update_inventory_ui")
	Server.connect("update_pouch_ui", self, "update_pouch_ui")
	Server.connect("update_spellbook_ui", self, "update_spellbook_ui")
	Server.connect("update_currency_ui", self, "update_currency_ui")
	
	
func update_equipment_ui(_data : Dictionary):
	ML_equipment.configure(_data)
	
	
func update_inventory_ui(_data : Array):
	ML_inventory.configure(_data)


func update_currency_ui(_data : Dictionary):
	ML_inventory.configure_currency(_data)

func update_pouch_ui(_data : Array):
	CL_pouch.configure(_data)
	ML_pouch.configure(_data)


func update_spellbook_ui(_data : Array):
	CL_spellbook.configure(_data)
	ML_spellbook.configure(_data)

	
func _physics_process(_delta: float) -> void:
	CL_debug.conf(Server.latency)
