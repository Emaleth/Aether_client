extends Node


onready var fast_processor = $FastProcessor
onready var slow_processor = $SlowProcessor
onready var unique_processor = $UniqueProcessor

onready var player_container := Node.new()
onready var npc_container := Node.new()
onready var ability_container := Node.new()
onready var resource_node_container := Node.new()
onready var shop_container := Node.new()
onready var crafting_station_container := Node.new()

onready var landscape_scene = preload("res://source/world/World.tscn")


func _ready():
	GlobalVariables.world = self
	add_child(landscape_scene.instance())
	create_containers()
	configure_processors()


func create_containers():
	add_child(player_container)
	add_child(npc_container)
	add_child(ability_container)
	add_child(resource_node_container)
	add_child(shop_container)
	add_child(crafting_station_container)
	
	
func configure_processors():
	fast_processor.configure(player_container, npc_container, ability_container)
	slow_processor.configure(player_container, npc_container, ability_container, resource_node_container)
	unique_processor.configure(shop_container, crafting_station_container)
	Server.connect("sig_update_fast_world_state", fast_processor, "update_world_state")
	Server.connect("sig_update_slow_world_state", slow_processor, "update_world_state")
#	Server.connect("sig_configure_unique_world_state", unique_processor, "configure_world_state")
