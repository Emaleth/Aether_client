extends Control

# DEBUG PANELS
onready var latency_label = $LatencyDEBUG/Label
# resource bars
onready var health_bar = $Resources/VBoxContainer/ContentPanel/VBoxContainer/HealthBar
onready var mana_bar = $Resources/VBoxContainer/ContentPanel/VBoxContainer/ManaBar
# TOP RIGHT
onready var minimap_module = $Minimap

onready var eq = $Equipment
onready var inventory = $Inventory
#onready var skill_panel = $MarginContainer/BottomMiddlePanel/BottomMiddle/SkillPanel

func _ready() -> void:
	Server.connect("update_equipment_data", eq, "configure")
	Server.request_equipment_data()
	Server.connect("update_inventory_data", inventory, "configure")
	Server.request_inventory_data()
	
func get_minimap_pivot_path():
	return minimap_module.get_pivot_path()
	
func _physics_process(_delta: float) -> void:
	latency_label.text = "Latency: %sms" % (Server.latency)
	
func update_resources_bar(_res):
	health_bar.update_ui(_res["health"]["current"], _res["health"]["max"])
	mana_bar.update_ui(_res["mana"]["current"], _res["mana"]["max"])

func _on_Interface_resized() -> void:
	pass
#	for i in get_children():
#		i.rect_global_position.x = clamp(i.rect_global_position.x, 0, rect_size.x - i.rect_size.x)
#		i.rect_global_position.y = clamp(i.rect_global_position.y, 0, rect_size.y - i.rect_size.y)
