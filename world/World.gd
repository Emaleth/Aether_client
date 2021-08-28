extends Node

onready var dummy_scene = preload("res://actors/Dummy.tscn")

var last_world_state = 0


func _ready():
	Server.connect("spawn_player", self, "spawn_player")
	Server.connect("despawn_player", self, "despawn_player")
	Server.connect("sig_update_world_state", self, "update_world_state")
	
func spawn_player(id, pos):
	if id == get_tree().get_network_unique_id():
		pass
	else:
		var new_player = dummy_scene.instance()
		new_player.transform = pos
		new_player.name = str(id)
		$Actors.add_child(new_player)

func despawn_player(id):
	$Actors.get_node(str(id)).queue_free()

func update_world_state(world_state):
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state.erase("T")
		world_state.erase(get_tree().get_network_unique_id())
		for player in world_state.keys():
			if $Actors.has_node(str(player)):
				$Actors.get_node(str(player)).move_player(world_state[player]["P"])
			else:
				print_debug("spawning_player")
				spawn_player(player, world_state[player]["P"])
