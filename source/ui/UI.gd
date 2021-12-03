extends PanelContainer

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


func _unhandled_key_input(_event: InputEventKey) -> void:
	pass
	
	
func _ready() -> void:
	connect_signals()
	connect_button()
	
	
func connect_signals():
	Server.connect("update_equipment_ui", self, "update_equipment_ui")
	Server.connect("update_inventory_ui", self, "update_inventory_ui")
	Server.connect("update_pouch_ui", self, "update_pouch_ui")
	Server.connect("update_spellbook_ui", self, "update_spellbook_ui")
	
	
func connect_button():
	buttons.connect("toggled_equipment_window", self, "toggle_equipment")
	buttons.connect("toggled_inventory_window", self, "toggle_inventory")
	
	
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

	
func toggle_inventory():
	if inventory.visible:
		inventory.hide()
	else:
		inventory.show()
		inventory.raise()

	
func toggle_equipment():
	if equipment.visible:
		equipment.hide()
	else:
		equipment.show()
		equipment.raise()
