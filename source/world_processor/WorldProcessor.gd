extends Node


onready var fast_processor = $FastProcessor
onready var slow_processor = $SlowProcessor

onready var world := $World

onready var player_container := $World/PlayerContainer
onready var ability_container := $World/AbilityContainer
onready var npc_container := $World/NPCContainer
onready var resource_node_container := $World/ResourceNodeContainer
onready var shop_container := $World/ShopContainer
onready var crafting_station_container := $World/CraftingStationContainer


func _ready():
	GlobalVariables.world = self
	configure_processors()
	
	
func configure_processors():
	# FAST
	fast_processor.configure(player_container, npc_container)
	Server.connect("sig_update_fast_world_state", fast_processor, "update_world_state")
	# SLOW
	slow_processor.configure(player_container, npc_container, resource_node_container, ability_container)
	Server.connect("sig_update_slow_world_state", slow_processor, "update_world_state")
	# UNIQUE

