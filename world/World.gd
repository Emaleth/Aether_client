extends Node

onready var character_scene = preload("res://actors/character/Character.tscn")

onready var character_container = $Character
onready var dummy_container = $Dummies
onready var npc_container = $NPCs

var last_world_state = 0
var world_state_buffer = []
const interpolation_offset = 100

var player_buffer = {}
var npc_buffer = {}


func _ready():
	Server.connect("s_update_world_state", self, "update_world_state")
	spawn_character()

func _physics_process(_delta: float) -> void:
	add_to_the_tree()
	interpolate_or_extrapolate()

func add_to_the_tree():
	for i in player_buffer.keys():
		if not dummy_container.has_node(str(i)):
			var new_player = ObjectPool.get_item("dummy")
			new_player.name = str(i)
			dummy_container.add_child(new_player, true)
			
	for i in npc_buffer.keys():
		if not npc_container.has_node(str(i)):
			var new_npc = ObjectPool.get_item("npc")
			new_npc.name = str(i)
			npc_container.add_child(new_npc, true)
		
func spawn_character():
	var p = character_scene.instance()
	character_container.add_child(p)
	p.global_transform.origin = Vector3(0, 1, 0)
	
func spawn_player(_id, _data):
	if _id == get_tree().get_network_unique_id():
		pass
	else:
		player_buffer[_id] = {}
		player_buffer[_id]["pos"] = _data["pos"]
		player_buffer[_id]["rot"] = _data["rot"]

func despawn_player(_id):
	player_buffer.erase(_id)
	if dummy_container.has_node(str(_id)):
		dummy_container.get_node(str(_id)).despawn()
		
func spawn_npc(_id, _data): 
	npc_buffer[_id] = {}
	npc_buffer[_id]["pos"] = _data["pos"]
	npc_buffer[_id]["rot"] = _data["rot"]
	npc_buffer[_id]["hp"] = _data["hp"]
	npc_buffer[_id]["max_hp"] = _data["max_hp"]
	npc_buffer[_id]["type"] = _data["type"]
	npc_buffer[_id]["state"] = _data["state"]
	
func despawn_enemy(id):
	yield(get_tree().create_timer(0.2), "timeout")
	npc_buffer.erase(id)
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
			spawn_player(player, world_state_buffer[2]["P"][player])
		if player_buffer.has(player):
			player_buffer[player]["pos"] = world_state_buffer[2]["P"][player]["pos"]
	for p in player_buffer:
		if not world_state_buffer[2]["P"].keys().has(p):
			despawn_player(p)
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
		if npc_buffer.has(enemy):
			npc_buffer[enemy]["pos"] = world_state_buffer[2]["E"][enemy]["pos"]
	for e in npc_buffer:
		if not world_state_buffer[2]["E"].keys().has(e):
			despawn_enemy(e)
				
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

