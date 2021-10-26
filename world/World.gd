extends Node

const interpolation_offset = 100 # milliseconds

var last_world_state = 0
var world_state_buffer = []
var npc_collection = {}
var pc_collection = {}
var bullet_collection = {}

var player
var gui

onready var character_container = $Character
onready var pc_container = $PCContainer
onready var npc_container = $NPCContainer
onready var bullet_container = $BulletContainer

onready var character_scene = preload("res://actors/character/Character.tscn")
onready var gui_scene = preload("res://ui/gui/GUI.tscn")
onready var camera_rig_scene = preload("res://actors/character/camera_rig/CameraRig.tscn")
onready var dummy_actor_scene = preload("res://actors/dummy_actor/dummy_actor.tscn")
onready var dummy_bullet_scene = preload("res://bullet/dummyBullet.tscn")

func _ready():
	Server.connect("s_update_world_state", self, "update_world_state")
	spawn_character()

func _physics_process(_delta: float) -> void:
	interpolate_or_extrapolate()
	# pc
	add_pc_to_the_tree()
	update_pc_in_the_tree()
	remove_pc_from_the_tree()
	# npc
	add_npc_to_the_tree()
	update_npc_in_the_tree()
	remove_npc_from_the_tree()
	# bullet
	add_bullet_to_the_tree()
	update_bullet_in_the_tree()
	remove_bullet_from_the_tree()
	
func add_pc_to_the_tree():
	for pc in pc_collection.keys():
		if pc == get_tree().get_network_unique_id():
			continue 
		if not pc_container.has_node(str(pc)):
			var new_pc = dummy_actor_scene.instance()
			new_pc.name = str(pc)
			pc_container.add_child(new_pc, true)
#			new_pc.configure(pc_collection[pc]["max_hp"])
	
func update_pc_in_the_tree():
	for pc in pc_collection.keys():
		if pc_container.has_node(str(pc)):
			pc_container.get_node(str(pc)).update(pc_collection[pc]["pos"], pc_collection[pc]["rot"], pc_collection[pc]["hp"], pc_collection[pc]["max_hp"])
		if pc == get_tree().get_network_unique_id():
			gui.update_health_bar(pc_collection[pc]["hp"], pc_collection[pc]["max_hp"])
#			character_container.get_child(0).gui.update_mana_bar(pc_collection[pc]["mp"], pc_collection[pc]["max_mp"])
		
	
func remove_pc_from_the_tree():
	for pc in pc_container.get_children():
		if pc_collection.has(pc.name):
			pc_container.get_node(str(pc)).queue_free()
	
func add_npc_to_the_tree():
	for npc in npc_collection.keys():
		if not npc_container.has_node(str(npc)):
			var new_npc = dummy_actor_scene.instance()
			new_npc.name = str(npc)
			npc_container.call_deferred("add_child", new_npc, true)
#			new_npc.update(npc_collection[npc]["pos"], npc_collection[npc]["rot"], npc_collection[npc]["hp"], npc_collection[npc]["max_hp"])
			
func update_npc_in_the_tree():
	for npc in npc_container.get_children():
		if npc_collection.has(str(npc.name)):
			npc.update(npc_collection[str(npc.name)]["pos"], npc_collection[str(npc.name)]["rot"], npc_collection[str(npc.name)]["hp"], npc_collection[str(npc.name)]["max_hp"])
			
func remove_npc_from_the_tree():
	for npc in npc_container.get_children():
		if not npc_collection.has(str(npc.name)):
			npc.call_deferred("queue_free")
	
func add_bullet_to_the_tree():
	for bullet in bullet_collection.keys():
		if not bullet_container.has_node(str(bullet)):
			if bullet_collection[bullet]["p_id"] == get_tree().get_network_unique_id():
				continue
			var new_bullet = dummy_bullet_scene.instance()
			new_bullet.name = str(bullet)
			new_bullet.transform.origin = bullet_collection[bullet]["pos"]
			new_bullet.transform.basis = bullet_collection[bullet]["rot"]
			new_bullet.type = bullet_collection[bullet]["type"]
			bullet_container.call_deferred("add_child", new_bullet, true)
			
func update_bullet_in_the_tree():
	for bullet in bullet_container.get_children():
		if bullet_collection.has(bullet.name):
			bullet.update(bullet_collection[bullet.name]["pos"], bullet_collection[bullet.name]["rot"])
			
func remove_bullet_from_the_tree():
	for bullet in bullet_container.get_children():
		if not bullet_collection.has(bullet.name):
			bullet.call_deferred("queue_free")
			
func spawn_character():
	player = character_scene.instance()
	character_container.add_child(player)
	player.global_transform.origin = Vector3(0, 1, 0)
	var camera_rig = camera_rig_scene.instance()
	character_container.add_child(camera_rig)
	gui = gui_scene.instance()
	character_container.add_child(gui)

	player.get_node("MinimapRemoteTransform").remote_path = gui.minimap_camera_pivot.get_path()
	player.get_node("CameraRigTransform").remote_path = camera_rig.get_path()
	camera_rig.connect("mouse_target", gui, "show_tooltip")

func add_pc_to_the_collection(_id, _data):
	pc_collection[_id] = {}
	pc_collection[_id]["pos"] = _data["pos"]
	pc_collection[_id]["rot"] = _data["rot"]
	pc_collection[_id]["hp"] = _data["hp"]
	pc_collection[_id]["max_hp"] = _data["max_hp"]

func update_pc_inside_the_collection(_id, _pos, _rot, _hp):
	pc_collection[_id]["pos"] = _pos
	pc_collection[_id]["rot"] = _rot
	if _hp != null:
		pc_collection[_id]["hp"] = _hp
	

func remove_pc_from_the_collection(_id):
	pc_collection.erase(_id)
		
func add_npc_to_the_collection(_id, _data): 
	npc_collection[_id] = {}
	npc_collection[_id]["pos"] = _data["pos"]
	npc_collection[_id]["rot"] = _data["rot"]
	npc_collection[_id]["hp"] = _data["hp"]
	npc_collection[_id]["max_hp"] = _data["max_hp"]
	
func update_npc_inside_the_collection(_id, _pos, _rot, _hp):
	npc_collection[_id]["pos"] = _pos
	npc_collection[_id]["rot"] = _rot
	if _hp != null:
		npc_collection[_id]["hp"] = _hp
	
func remove_npc_from_the_collection(_id):
	npc_collection.erase(_id)
	
func add_bullet_to_the_collection(_id, _data):
	bullet_collection[_id] = {}
	bullet_collection[_id]["pos"] = _data["pos"]
	bullet_collection[_id]["rot"] = _data["rot"]
	bullet_collection[_id]["p_id"] = _data["p_id"]
	
func update_bullet_inside_the_collection(_id, _pos, _rot):
	bullet_collection[_id]["pos"] = _pos
	bullet_collection[_id]["rot"] = _rot

func remove_bullet_from_the_collection(_id):
	bullet_collection.erase(_id)
	
func update_world_state(_world_state):
	if _world_state["T"] > last_world_state:
		last_world_state = _world_state["T"]
		world_state_buffer.append(_world_state)
	
func interpolate_or_extrapolate():
	var render_time = Server.client_clock - interpolation_offset
	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[2].T:
			world_state_buffer.remove(0)
		if world_state_buffer.size() > 2:
			interpolate(render_time)
		elif render_time > world_state_buffer[1].T:
			extrapolate(render_time)
	
func interpolate(_render_time):
	var interpolation_factor = float(_render_time - world_state_buffer[1]["T"]) / float(world_state_buffer[2]["T"] - world_state_buffer[1]["T"])
	# PLAYERS
	for pc in world_state_buffer[2]["P"].keys():
#		if pc == get_tree().get_network_unique_id():
#			continue
		if not world_state_buffer[1]["P"].has(pc): # WE WANT TO BE SURE THAT BOTH WS1 AND WS2 HAVE ANY GIVEN KEY FOR INTERPOLATION'S SAKE
			continue
		if pc_collection.has(str(pc)):
			var new_position = lerp(world_state_buffer[1]["P"][pc]["pos"], world_state_buffer[2]["P"][pc]["pos"], interpolation_factor)
			var current_rot = Quat(world_state_buffer[1]["P"][pc]["rot"])
			var target_rot = Quat(world_state_buffer[2]["P"][pc]["rot"])
			var new_rotation = Basis(current_rot.slerp(target_rot, interpolation_factor))
			var new_hp = world_state_buffer[2]["P"][pc]["hp"]
			update_pc_inside_the_collection(pc, new_position, new_rotation, new_hp)
		else:
			add_pc_to_the_collection(pc, world_state_buffer[2]["P"][pc])
	for pc in pc_collection:
		if not world_state_buffer[2]["P"].keys().has(pc):
			remove_pc_from_the_collection(pc)
			
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
			update_npc_inside_the_collection(npc, new_position, new_rotation, new_hp)
		else:
			add_npc_to_the_collection(npc, world_state_buffer[2]["E"][npc])
	for npc in npc_collection:
		if not world_state_buffer[2]["E"].keys().has(npc):
			remove_npc_from_the_collection(npc)
			
	# BULLET
	for bullet in world_state_buffer[2]["B"].keys():
#		print_debug(bullet)
		if not world_state_buffer[1]["B"].has(bullet): # WE WANT TO BE SURE THAT BOTH WS1 AND WS2 HAVE ANY GIVEN KEY FOR INTERPOLATION'S SAKE
			continue
#		if world_state_buffer[2]["B"][bullet]["p_id"] == get_tree().get_network_unique_id():
#			continue
		if bullet_collection.has(bullet):
			var new_position = lerp(world_state_buffer[1]["B"][bullet]["pos"], world_state_buffer[2]["B"][bullet]["pos"], interpolation_factor)
			var current_rot = Quat(world_state_buffer[1]["B"][bullet]["rot"])
			var target_rot = Quat(world_state_buffer[2]["B"][bullet]["rot"])
			var new_rotation = Basis(current_rot.slerp(target_rot, interpolation_factor))
			update_bullet_inside_the_collection(bullet, new_position, new_rotation)
		else:
			add_bullet_to_the_collection(bullet, world_state_buffer[2]["B"][bullet])
	for bullet in bullet_collection:
		if not world_state_buffer[2]["B"].keys().has(bullet):
			remove_bullet_from_the_collection(bullet)
	
func extrapolate(_render_time):
	var extrapolation_factor = float(_render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.00
	# PLAYERS
	for pc in world_state_buffer[1]["P"].keys():
		if pc == get_tree().get_network_unique_id():
			continue
		if not world_state_buffer[0]["P"].has(pc): # WE WANT TO BE SURE THAT BOTH WS0 AND WS1 HAVE ANY GIVEN KEY FOR EXTRAPOLATION'S SAKE
			continue
		if pc_collection.has(pc):
			var position_delta = (world_state_buffer[1]["P"][pc]["pos"] - world_state_buffer[0]["P"][pc]["pos"]) 
			var new_position = world_state_buffer[1]["P"][pc]["pos"] + (position_delta * extrapolation_factor)
			var current_rot = Quat(world_state_buffer[1]["P"][pc]["rot"])
			var old_rot = Quat(world_state_buffer[0]["P"][pc]["rot"])
			var rotation_delta = (current_rot - old_rot) 
			var new_rotation = Basis(current_rot + (rotation_delta * extrapolation_factor))
			update_pc_inside_the_collection(pc, new_position, new_rotation, null)
			
	# ENEMIES
	for npc in world_state_buffer[1]["E"].keys():
		if not world_state_buffer[0]["E"].has(npc): # WE WANT TO BE SURE THAT BOTH WS0 AND WS1 HAVE ANY GIVEN KEY FOR EXTRAPOLATION'S SAKE
			continue
		if npc_collection.has(npc):
			var position_delta = (world_state_buffer[1]["E"][npc]["pos"] - world_state_buffer[0]["E"][npc]["pos"]) 
			var new_position = world_state_buffer[1]["E"][npc]["pos"] + (position_delta * extrapolation_factor)
			var current_rot = Quat(world_state_buffer[1]["E"][npc]["rot"])
			var old_rot = Quat(world_state_buffer[0]["E"][npc]["rot"])
			var rotation_delta = (current_rot - old_rot) 
			var new_rotation = Basis(current_rot + (rotation_delta * extrapolation_factor))
			update_npc_inside_the_collection(npc, new_position, new_rotation, null)

	# BULLET
	for bullet in world_state_buffer[1]["B"].keys():
		if not world_state_buffer[0]["B"].has(bullet): # WE WANT TO BE SURE THAT BOTH WS0 AND WS1 HAVE ANY GIVEN KEY FOR EXTRAPOLATION'S SAKE
			continue
		if bullet_collection.has(bullet):
			var position_delta = (world_state_buffer[1]["B"][bullet]["pos"] - world_state_buffer[0]["B"][bullet]["pos"]) 
			var new_position = world_state_buffer[1]["B"][bullet]["pos"] + (position_delta * extrapolation_factor)
			var current_rot = Quat(world_state_buffer[1]["B"][bullet]["rot"])
			var old_rot = Quat(world_state_buffer[0]["B"][bullet]["rot"])
			var rotation_delta = (current_rot - old_rot) 
			var new_rotation = Basis(current_rot + (rotation_delta * extrapolation_factor))
			update_bullet_inside_the_collection(bullet, new_position, new_rotation)
