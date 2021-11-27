extends Control

onready var resources := $Resources
onready var minimap := $Minimap
onready var grid := $Grid
onready var debug := $Debug
onready var equipment := $Equipment
onready var inventory := $Inventory
onready var spellbook := $AbilityBar
onready var pouch := $Pouch
onready var buttons := $Buttons

	
func enable_edit_mode(_b : bool):
	grid.conf(_b)
	for i in get_children():
		if i.has_method("enable_edit_mode"):
			i.enable_edit_mode(_b)
	
func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("edit_ui"):
		enable_edit_mode(true)
	if event.is_action_pressed("normal_ui"):
		enable_edit_mode(false)
		
func _ready() -> void:
	Server.connect("update_equipment_ui", self, "update_equipment_ui")
	Server.connect("update_inventory_ui", self, "update_inventory_ui")
	Server.connect("update_pouch_ui", self, "update_pouch_ui")
	Server.connect("update_spellbook_ui", self, "update_spellbook_ui")
	
	enable_edit_mode(false)
	connect_button()
		
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

func _on_Interface_resized() -> void:
	for i in get_children():
		if i.has_method("enable_edit_mode"):
			i.resize()
