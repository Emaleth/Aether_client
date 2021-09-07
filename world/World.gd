extends Node

onready var character_scene = preload("res://actors/character/Character.tscn")

onready var character_container = $Character
onready var dummy_container = $Dummies
onready var npc_container = $NPCs

var last_world_state = 0
var world_state_buffer = []
const interpolation_offset = 100

var player_list = {}
var npc_list = {}


func _ready():
	Server.connect("s_spawn_player", self, "spawn_player")
	Server.connect("s_despawn_player", self, "despawn_player")
	Server.connect("s_update_world_state", self, "update_world_state")
	spawn_character()

func _physics_process(_delta: float) -> void:
	add_to_the_tree()
	interpolate_or_extrapolate()

func add_to_the_tree():
	for i in player_list.keys():
		if not dummy_container.has_node(str(i)):
			var new_player = ObjectPool.get_item("dummy")
			new_player.name = str(i)
			dummy_container.add_child(new_player, true)
			
	for i in npc_list.keys():
		if not npc_container.has_node(str(i)):
			var new_npc = ObjectPool.get_item("npc")
			new_npc.name = str(i)
			npc_container.add_child(new_npc, true)
		
func spawn_character():
	var p = character_scene.instance()
	character_container.add_child(p)
	p.global_transform.origin = Vector3(0, 1, 0)
	
func spawn_player(id, pos, rot):
	if id == get_tree().get_network_unique_id():
		pass
	else:
		player_list[id] = {}
		player_list[id]["pos"] = pos
		player_list[id]["rot"] = rot

func despawn_player(id):
	yield(get_tree().create_timer(0.2), "timeout")
	player_list.erase(id)
	if dummy_container.has_node(str(id)):
		dummy_container.get_node(str(id)).despawn()
		
func spawn_npc(id, dict): 
	npc_list[id] = {}
	npc_list[id]["pos"] = dict["pos"]
	npc_list[id]["rot"] = dict["rot"]
	npc_list[id]["hp"] = dict["hp"]
	npc_list[id]["max_hp"] = dict["max_hp"]
	npc_list[id]["type"] = dict["type"]
	npc_list[id]["state"] = dict["state"]
	
func despawn_enemy(id):
	yield(get_tree().create_timer(0.2), "timeout")
	npc_list.erase(id)
	if npc_container.has_node(str(id)):
		npc_container.get_node(str(id)).despawn()
	
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
	# PLAYERS
	for player in world_state_buffer[2]["P"].keys():
		if player == get_tree().get_network_unique_id():
			continue
		if not world_state_buffer[1]["P"].has(player):
			continue
		if dummy_container.has_node(str(player)):
			# pos
			var new_position = lerp(world_state_buffer[1]["P"][player]["pos"], world_state_buffer[2]["P"][player]["pos"], interpolation_factor)
			# rot
			var current_rot = Quat(world_state_buffer[1]["P"][player]["rot"])
			var target_rot = Quat(world_state_buffer[2]["P"][player]["rot"])
			var new_rotation = Basis(current_rot.slerp(target_rot, interpolation_factor))
			var new_animation = world_state_buffer[2]["P"][player]["anim"]
			dummy_container.get_node(str(player)).move_player(new_position, new_rotation, new_animation)
		else:
			print("player %s not yet spawned" % player)
#			spawn_player(player, world_state_buffer[2]["P"][player]["pos"], world_state_buffer[2]["P"][player]["rot"])
		if player_list.has(player):
			player_list[player]["pos"] = world_state_buffer[2]["P"][player]["pos"]
		
	# ENEMIES
	for enemy in world_state_buffer[2]["E"].keys():
		if not world_state_buffer[1]["E"].has(enemy):
			continue
		if npc_container.has_node(str(enemy)):
			# pos
			var new_position = lerp(world_state_buffer[1]["E"][enemy]["pos"], world_state_buffer[2]["E"][enemy]["pos"], interpolation_factor)
			# rot
			var current_rot = Quat(world_state_buffer[1]["E"][enemy]["rot"])
			var target_rot = Quat(world_state_buffer[2]["E"][enemy]["rot"])
			var new_rotation = Basis(current_rot.slerp(target_rot, interpolation_factor))
			npc_container.get_node(str(enemy)).move_player(new_position, new_rotation)
			npc_container.get_node(str(enemy)).set_health(world_state_buffer[1]["E"][enemy]["hp"])
		else:
			spawn_npc(enemy, world_state_buffer[2]["E"][enemy])
		if npc_list.has(enemy):
			npc_list[enemy]["pos"] = world_state_buffer[2]["E"][enemy]["pos"]
	
func extrapolate(render_time):
	var extrapolation_factor = float(render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.00
	# PLAYERS
	for player in world_state_buffer[1]["P"].keys():
		if player == get_tree().get_network_unique_id():
			continue
		if not world_state_buffer[0]["P"].has(player):
			continue
		if dummy_container.has_node(str(player)):
			# pos
			var position_delta = (world_state_buffer[1]["P"][player]["pos"] - world_state_buffer[0]["P"][player]["pos"]) 
			var new_position = world_state_buffer[1]["P"][player]["pos"] + (position_delta * extrapolation_factor)
			# rot
			var current_rot = Quat(world_state_buffer[1]["P"][player]["rot"])
			var target_rot = Quat(world_state_buffer[0]["P"][player]["rot"])
			var rotation_delta = (current_rot - target_rot) 
			var new_rotation = Basis(current_rot + (rotation_delta * extrapolation_factor))
			dummy_container.get_node(str(player)).move_player(new_position, new_rotation)
			
	# ENEMIES
	for enemy in world_state_buffer[1]["E"].keys():
		if not world_state_buffer[0]["E"].has(enemy):
			continue
		if npc_container.has_node(str(enemy)):
			# pos
			var position_delta = (world_state_buffer[1]["E"][enemy]["pos"] - world_state_buffer[0]["E"][enemy]["pos"]) 
			var new_position = world_state_buffer[1]["E"][enemy]["pos"] + (position_delta * extrapolation_factor)
			# rot
			var current_rot = Quat(world_state_buffer[1]["E"][enemy]["rot"])
			var target_rot = Quat(world_state_buffer[0]["E"][enemy]["rot"])
			var rotation_delta = (current_rot - target_rot) 
			var new_rotation = Basis(current_rot + (rotation_delta * extrapolation_factor))
			npc_container.get_node(str(enemy)).move_player(new_position, new_rotation)

