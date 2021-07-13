extends Node

onready var dummy_scene = preload("res://actors/Dummy.tscn")

func _ready():
	Server.connect("spawn_player", self, "spawn_player")
	Server.connect("despawn_player", self, "despawn_player")

func spawn_player(id, pos):
	if id == get_tree().get_network_unique_id():
		pass
	else:
		var new_player = dummy_scene.instance()
		new_player.transform.origin = pos
		new_player.name = str(id)
		$Actors.add_child(new_player)

func despawn_player(id):
	$Actors.get_node(str(id)).queue_free()
