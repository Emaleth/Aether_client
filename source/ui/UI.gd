extends PanelContainer

# COMBAT LAYER PANELS
export(NodePath) var resources_node
onready var resources := get_node(resources_node)

export(NodePath) var minimap_node
onready var minimap := get_node(minimap_node)

export(NodePath) var debug_node
onready var debug := get_node(debug_node)

export(NodePath) var equipment_node
onready var equipment := get_node(equipment_node)

export(NodePath) var inventory_node
onready var inventory := get_node(inventory_node)

export(NodePath) var spellbook_node
onready var spellbook := get_node(spellbook_node)

export(NodePath) var pouch_node
onready var pouch := get_node(pouch_node)

export(NodePath) var buttons_node
onready var buttons := get_node(buttons_node)
# MANAGMENT LAYER PANELS
enum {COMBAT, MANAGMENT}
var current_mode
func _unhandled_key_input(_event: InputEventKey) -> void:
	if Input.is_action_just_pressed("ui_layer"):
		switch_mode()


func switch_mode():
	if current_mode == COMBAT:
		set_mode(MANAGMENT)
	else:
		set_mode(COMBAT)


func set_mode(_mode):
	match _mode:
		COMBAT:
			$CombatGrid.show()
			$ManagmentGrid.hide()
		MANAGMENT:
			$CombatGrid.hide()
			$ManagmentGrid.show()


func _ready() -> void:
	set_mode(COMBAT)
	connect_signals()
	
	
func connect_signals():
	Server.connect("update_equipment_ui", self, "update_equipment_ui")
	Server.connect("update_inventory_ui", self, "update_inventory_ui")
	Server.connect("update_pouch_ui", self, "update_pouch_ui")
	Server.connect("update_spellbook_ui", self, "update_spellbook_ui")
	
	
func update_equipment_ui(_data : Dictionary):
	equipment.configure(_data)
	
	
func update_inventory_ui(_data : Array):
	inventory.configure(_data)


func update_pouch_ui(_data : Array):
	pouch.configure(_data)


func update_spellbook_ui(_data : Array):
	spellbook.configure(_data)

	
func get_minimap_pivot_path():
	return minimap.get_pivot_path()

	
func _physics_process(_delta: float) -> void:
	debug.conf(Server.latency)
