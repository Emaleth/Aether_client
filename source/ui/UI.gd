extends Control

var edit_mode := false
# DEBUG PANELS
onready var latency_label = $Label
# resource bars
onready var health_bar = $Resources/VBoxContainer/ContentPanel/VBoxContainer/HealthBar
onready var mana_bar = $Resources/VBoxContainer/ContentPanel/VBoxContainer/ManaBar
# TOP RIGHT
onready var minimap_module = $Minimap

onready var grid := $Grid

onready var equipment = $Equipment
onready var inventory = $Inventory
onready var pouch = $Pouch
onready var buttons = $Buttons
onready var toobag 

	
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
	Server.request_equipment_data()
	Server.request_inventory_data()
	Server.request_pouch_data()
	
	Server.connect("update_equipment_ui", self, "update_equipment_ui")
	Server.connect("update_inventory_ui", self, "update_inventory_ui")
	Server.connect("update_pouch_ui", self, "update_pouch_ui")
	
	
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
	
func get_minimap_pivot_path():
	return minimap_module.get_pivot_path()
	
func _physics_process(_delta: float) -> void:
	latency_label.text = "Latency: %sms" % (Server.latency)
	
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
	
func update_resources_bar(_res):
	health_bar.update_ui(_res["health"]["current"], _res["health"]["max"])
	mana_bar.update_ui(_res["mana"]["current"], _res["mana"]["max"])

func _on_Interface_resized() -> void:
	for i in get_children():
		if i.has_method("enable_edit_mode"):
			i.rect_global_position.x = clamp(i.rect_global_position.x, 0, OS.window_size.x - i.rect_size.x)
			i.rect_global_position.y = clamp(i.rect_global_position.y, 0, OS.window_size.y - i.rect_size.y)
			i.resize()
