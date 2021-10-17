extends Node

const interpolation_offset = 100 # milliseconds

var last_world_state = 0
var world_state_buffer = []
var npc_collection = {}
var pc_collection = {}

onready var character_container = $Character
onready var pc_container = $Dummies
onready var npc_container = $NPCs
onready var character_scene = preload("res://actors/character/Character.tscn")


func _ready():
	Server.connect("s_update_world_state", self, "update_world_state")
	spawn_character()

func _physics_process(_delta: float) -> void:
	interpolate_or_extrapolate()
	# pc
	add_pc_to_the_tree()
	# npc
	add_npc_to_the_tree()
	update_npc_in_the_tree()
	remove_npc_from_the_tree()

func add_pc_to_the_tree():
	for i in pc_collection.keys():
		if not pc_container.has_node(str(i)):
			var new_player = ObjectPool.get_item("dummy")
			new_player.name = str(i)
			pc_container.add_child(new_player, true)
			
func remove_pc_from_the_tree():
	pass
	
func add_npc_to_the_tree():
	for npc in npc_collection.keys():
		if not npc_container.has_node(str(npc)):
			var new_npc = ObjectPool.get_item("npc")
			new_npc.name = str(npc)
			npc_container.add_child(new_npc, true)
			new_npc.configure(npc_collection[npc]["max_hp"], npc_collection[npc]["type"], npc_collection[npc]["state"])

func update_npc_in_the_tree():
	for npc in npc_collection.keys():
		if npc_container.has_node(str(npc)):
			npc_container.get_node(str(npc)).update(npc_collection[npc]["pos"], npc_collection[npc]["rot"], npc_collection[npc]["hp"])
			
func remove_npc_from_the_tree():
	for npc in npc_container.get_children():
		if npc_collection.has(npc.name):
			npc_container.get_node(str(npc)).despawn()
	
func spawn_character():
	var p = character_scene.instance()
	character_container.add_child(p)
	p.global_transform.origin = Vector3(0, 1, 0)
	
func spawn_player(_id, _data):
	if _id == get_tree().get_network_unique_id():
		pass
	else:
		pc_collection[_id] = {}
		pc_collection[_id]["pos"] = _data["pos"]
		pc_collection[_id]["rot"] = _data["rot"]

func despawn_player(_id):
	pc_collection.erase(_id)
	if pc_container.has_node(str(_id)):
		pc_container.get_node(str(_id)).despawn()
		
func add_npc_to_the_collection(_id, _data): 
	npc_collection[_id] = {}
	npc_collection[_id]["pos"] = _data["pos"]
	npc_collection[_id]["rot"] = _data["rot"]
	npc_collection[_id]["hp"] = _data["hp"]
	npc_collection[_id]["max_hp"] = _data["max_hp"]
	npc_collection[_id]["type"] = _data["type"]
	npc_collection[_id]["state"] = _data["state"]
	
func update_npc_inside_the_collection(_id, _pos, _rot, _hp):
	npc_collection[_id]["pos"] = _pos
	npc_collection[_id]["rot"] = _rot
	if _hp != null:
		npc_collection[_id]["hp"] = _hp
	
func remove_npc_from_the_collection(_id):
	yield(get_tree().create_timer(0.2), "timeout")
	npc_collection.erase(_id)
	
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
		if pc_container.has_node(str(player)):
			# pos
			var new_position = lerp(world_state_buffer[1]["P"][player]["pos"], world_state_buffer[2]["P"][player]["pos"], interpolation_factor)
			# rot
			var current_rot = Quat(world_state_buffer[1]["P"][player]["rot"])
			var target_rot = Quat(world_state_buffer[2]["P"][player]["rot"])
			var new_rotation = Basis(current_rot.slerp(target_rot, interpolation_factor))
			var new_animation = world_state_buffer[2]["P"][player]["anim"]
			pc_container.get_node(str(player)).move_player(new_position, new_rotation, new_animation)
		else:
			spawn_player(player, world_state_buffer[2]["P"][player])
		if pc_collection.has(player):
			pc_collection[player]["pos"] = world_state_buffer[2]["P"][player]["pos"]
	for p in pc_collection:
		if not world_state_buffer[2]["P"].keys().has(p):
			despawn_player(p)
	# ENEMIES
	for npc in world_state_buffer[2]["E"].keys():
		if not world_state_buffer[1]["E"].has(npc): # WE WANT TO BE SURE THAT BOTH WS1 AND WS2 HAVE ANY GIVEN KEY FOR INTERPOLATION'S SAKE
			continue
		if npc_collection.has(npc):
			var new_position = lerp(world_state_buffer[1]["E"][npc]["pos"], world_state_buffer[2]["E"][npc]["pos"], interpolation_factor)
			var current_rot = Quat(world_state_buffer[1]["E"][npc]["rot"])
			var target_rot = Quat(world_state_buffer[2]["E"][npc]["rot"])
			var new_rotation = Basis(current_rot.slerp(target_rot, interpolation_factor))
			var new_hp = world_state_buffer[2]["E"][npc]["hp"]
			update_npc_inside_the_collection(npc, new_position, new_rotation, new_hp )
		else:
			add_npc_to_the_collection(npc, world_state_buffer[2]["E"][npc])
	for npc in npc_collection:
		if not world_state_buffer[2]["E"].keys().has(npc):
			remove_npc_from_the_collection(npc)
	
func extrapolate(render_time):
	var extrapolation_factor = float(render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.00
	# PLAYERS
	for player in world_state_buffer[1]["P"].keys():
		if player == get_tree().get_network_unique_id():
			continue
		if not world_state_buffer[0]["P"].has(player):
			continue
		if pc_container.has_node(str(player)):
			# pos
			var position_delta = (world_state_buffer[1]["P"][player]["pos"] - world_state_buffer[0]["P"][player]["pos"]) 
			var new_position = world_state_buffer[1]["P"][player]["pos"] + (position_delta * extrapolation_factor)
			# rot
			var current_rot = Quat(world_state_buffer[1]["P"][player]["rot"])
			var old_rot = Quat(world_state_buffer[0]["P"][player]["rot"])
			var rotation_delta = (current_rot - old_rot) 
			var new_rotation = Basis(current_rot + (rotation_delta * extrapolation_factor))
			pc_container.get_node(str(player)).move_player(new_position, new_rotation)
			
	# ENEMIES
	for npc in world_state_buffer[1]["E"].keys():
		if not world_state_buffer[0]["E"].has(npc): # WE WANT TO BE SURE THAT BOTH WS0 AND WS1 HAVE ANY GIVEN KEY FOR WXTRAPOLATION'S SAKE
			continue
		if npc_collection.has(npc):
			var position_delta = (world_state_buffer[1]["E"][npc]["pos"] - world_state_buffer[0]["E"][npc]["pos"]) 
			var new_position = world_state_buffer[1]["E"][npc]["pos"] + (position_delta * extrapolation_factor)
			var current_rot = Quat(world_state_buffer[1]["E"][npc]["rot"])
			var old_rot = Quat(world_state_buffer[0]["E"][npc]["rot"])
			var rotation_delta = (current_rot - old_rot) 
			var new_rotation = Basis(current_rot + (rotation_delta * extrapolation_factor))
			update_npc_inside_the_collection(npc, new_position, new_rotation, null)

