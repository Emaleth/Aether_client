extends Node

onready var dummy_scene = preload("res://actors/Dummy.tscn")

var last_world_state = 0
var world_state_buffer = []
const interpolation_offset = 100

func _ready():
	Server.connect("spawn_player", self, "spawn_player")
	Server.connect("despawn_player", self, "despawn_player")
	Server.connect("sig_update_world_state", self, "update_world_state")
	
func spawn_player(id, pos):
	if id == get_tree().get_network_unique_id():
		pass
	else:
		var new_player = dummy_scene.instance()
		new_player.transform.origin = pos
		new_player.name = str(id)
		$Actors.add_child(new_player)

func despawn_player(id):
	yield(get_tree().create_timer(0.2), "timeout")
	$Actors.get_node(str(id)).queue_free()

func update_world_state(world_state):
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state_buffer.append(world_state)
		
func _physics_process(_delta: float) -> void:
	var render_time = OS.get_system_time_msecs() - interpolation_offset
	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[2].T:
			world_state_buffer.remove(0)
		# INTERPOLATION
		if world_state_buffer.size() > 2:
			var interpolation_factor = float(render_time - world_state_buffer[1]["T"]) / float(world_state_buffer[2]["T"] - world_state_buffer[1]["T"])
			for player in world_state_buffer[2].keys():
				if str(player) == "T":
					continue
				if player == get_tree().get_network_unique_id():
					continue
				if not world_state_buffer[1].has(player):
					continue
				if $Actors.has_node(str(player)):
					var new_position = lerp(world_state_buffer[1][player]["P"], world_state_buffer[2][player]["P"], interpolation_factor)
					$Actors.get_node(str(player)).move_player(new_position)
				else:
					spawn_player(player, world_state_buffer[2][player]["P"])
		# EXTRAPOLATION
		elif render_time > world_state_buffer[1].T:
			var extrapolation_factor = float(render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.00
			for player in world_state_buffer[1].keys():
				if str(player) == "T":
					continue
				if player == get_tree().get_network_unique_id():
					continue
				if not world_state_buffer[0].has(player):
					continue
				if $Actors.has_node(str(player)):
					var position_delta = (world_state_buffer[1][player]["P"] - world_state_buffer[0][player]["P"]) 
					var new_position = world_state_buffer[1][player]["P"] + (position_delta * extrapolation_factor)
					$Actors.get_node(str(player)).move_player(new_position)

