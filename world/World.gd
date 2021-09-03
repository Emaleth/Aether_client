extends Node

onready var dummy_scene = preload("res://actors/Dummy.tscn")
onready var enemy_scene = preload("res://actors/Enemy.tscn")

var last_world_state = 0
var world_state_buffer = []
const interpolation_offset = 100


func _ready():
	Server.connect("sig_spawn_player", self, "spawn_player")
	Server.connect("sig_despawn_player", self, "despawn_player")
	Server.connect("sig_update_world_state", self, "update_world_state")
	
func _physics_process(_delta: float) -> void:
	interpolate_or_extrapolate()

func spawn_player(id, pos, rot):
	if id == get_tree().get_network_unique_id():
		pass
	else:
		var new_player = dummy_scene.instance()
		new_player.transform.origin = pos
		new_player.transform.basis = rot
		new_player.name = str(id)
		$Actors.add_child(new_player)

func despawn_player(id):
	yield(get_tree().create_timer(0.2), "timeout")
	$Actors.get_node(str(id)).queue_free()

func spawn_enemy(id, dict):
	var new_enemy = enemy_scene.instance()
	new_enemy.transform.origin = dict["pos"]
#	new_enemy.transform.rotation = dict["rot"]
	new_enemy.max_hp = dict["max_hp"]
	new_enemy.current_hp = dict["hp"]
	new_enemy.type = dict["type"]
	new_enemy.state = dict["state"]
	new_enemy.name = str(id)
	$Actors.add_child(new_enemy, true)
	pass
	
func despawn_enemy(id):
	pass
	
func update_world_state(world_state):
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state_buffer.append(world_state)
	
func interpolate_or_extrapolate():
	var render_time = Server.client_clock - interpolation_offset
	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[2].T:
			world_state_buffer.remove(0)
		if world_state_buffer.size() > 2:
			interpolate(render_time)
		elif render_time > world_state_buffer[1].T:
			extrapolate(render_time)
	
func interpolate(render_time):
	var interpolation_factor = float(render_time - world_state_buffer[1]["T"]) / float(world_state_buffer[2]["T"] - world_state_buffer[1]["T"])
	for player in world_state_buffer[2].keys():
		if str(player) == "T":
			continue
		if str(player) == "E":
			continue
		if player == get_tree().get_network_unique_id():
			continue
		if not world_state_buffer[1].has(player):
			continue
		if $Actors.has_node(str(player)):
			# pos
			var new_position = lerp(world_state_buffer[1][player]["P"], world_state_buffer[2][player]["P"], interpolation_factor)
			# rot
			var current_rot = Quat(world_state_buffer[1][player]["R"])
			var target_rot = Quat(world_state_buffer[2][player]["R"])
			var new_rotation = Basis(current_rot.slerp(target_rot, interpolation_factor))
			$Actors.get_node(str(player)).move_player(new_position, new_rotation)
		else:
			spawn_player(player, world_state_buffer[2][player]["P"], world_state_buffer[2][player]["R"])
			
	for enemy in world_state_buffer[2]["E"].keys():
		if not world_state_buffer[1]["E"].has(enemy):
			continue
		if $Actors.has_node(str(enemy)):
			# pos
			var new_position = lerp(world_state_buffer[1]["E"][enemy]["pos"], world_state_buffer[2]["E"][enemy]["pos"], interpolation_factor)
			# rot
#			var current_rot = Quat(world_state_buffer[1]["E"][enemy]["rot"])
#			var target_rot = Quat(world_state_buffer[2]["E"][enemy]["rot"])
#			var new_rotation = Basis(current_rot.slerp(target_rot, interpolation_factor))
			$Actors.get_node(str(enemy)).move_player(new_position)#, new_rotation)
			$Actors.get_node(str(enemy)).set_health(world_state_buffer[1]["E"][enemy]["hp"])
		else:
			spawn_enemy(enemy, world_state_buffer[2]["E"][enemy])
			
func extrapolate(render_time):
	var extrapolation_factor = float(render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.00
	for player in world_state_buffer[1].keys():
		if str(player) == "T":
			continue
		if str(player) == "E":
			continue
		if player == get_tree().get_network_unique_id():
			continue
		if not world_state_buffer[0].has(player):
			continue
		if $Actors.has_node(str(player)):
			# pos
			var position_delta = (world_state_buffer[1][player]["P"] - world_state_buffer[0][player]["P"]) 
			var new_position = world_state_buffer[1][player]["P"] + (position_delta * extrapolation_factor)
			# rot
			var current_rot = Quat(world_state_buffer[1][player]["R"])
			var target_rot = Quat(world_state_buffer[0][player]["R"])
			var rotation_delta = (current_rot - target_rot) 
			var new_rotation = Basis(current_rot + (rotation_delta * extrapolation_factor))
			$Actors.get_node(str(player)).move_player(new_position, new_rotation)
	# TODO: ENMY EXTRAPOLATION ADN ROTATION
	for enemy in world_state_buffer[1]["E"].keys():
		if not world_state_buffer[0]["E"].has(enemy):
			continue
		if $Actors.has_node(str(enemy)):
			# pos
			var position_delta = (world_state_buffer[1]["E"][enemy]["pos"] - world_state_buffer[0]["E"][enemy]["pos"]) 
			var new_position = world_state_buffer[1]["E"][enemy]["pos"] + (position_delta * extrapolation_factor)
			# rot
#			var current_rot = Quat(world_state_buffer[1]["E"][enemy]["rot"])
#			var target_rot = Quat(world_state_buffer[0]["E"][enemy]["rot"])
#			var rotation_delta = (current_rot - target_rot) 
#			var new_rotation = Basis(current_rot + (rotation_delta * extrapolation_factor))
			$Actors.get_node(str(enemy)).move_player(new_position)#, new_rotation)

