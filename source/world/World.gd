extends Node

#################################_COMMENT_######################################

"""
"""

#################################_VAR_CONST_ENUM_###############################

onready var actor_scene : PackedScene = preload("res://source/actor/Actor.tscn")
onready var ability_scene : PackedScene 

onready var actor_container : Node = $Actors
onready var terrain : StaticBody = $Navigation/Terrain
onready var ability_container : Node = $Abilities
onready var navigation : Navigation = $Navigation

#################################_API_##########################################

remote func recive_actor_delta_snapshot(_snapshot : Dictionary):
	process_actor_delta_snapshot(_snapshot)


remote func recive_ability_delta_snapshot(_snapshot : Dictionary):
	process_ability_delta_snapshot(_snapshot)
	
func send_new_target_destination(_pos):
	rpc_id(1, "recive_new_target_destination", _pos)
	
###################################_MAIN_#######################################

func process_actor_delta_snapshot(_snapshot):
	for _id in _snapshot["spawned"].keys():
		spawn_actor(_id, _snapshot)
	for _id in _snapshot["changed"].keys():
		update_actor(_id, _snapshot)
	for _id in _snapshot["despawned"].keys():
		despawn_actor(_id, _snapshot)
		
	Ui.process_private_snapshot(_snapshot["private"])


func process_ability_delta_snapshot(_snapshot):
	for _id in _snapshot["spawned"].keys():
		spawn_ability(_id, _snapshot)
		
#############################_BUILT-IN_#########################################

func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass

#################################_FUNCTIONS_####################################

func spawn_actor(_id, _snapshot):
	var actor = actor_scene.instance()
	actor.name = str(_id)
	actor.configure(_snapshot["spawned"][_id])
	actor_container.add_child(actor, true)
	if _id == str(get_tree().get_network_unique_id()):
		actor.bind_camera(CameraRig.get_path())
		CameraRig.enable(true)
		terrain.grass_target = actor
	print("Spawned actor id: %s" % _id)
#
#
func update_actor(_id, _snapshot):
	var actor = actor_container.get_node(str(_id))
	var path = navigation.get_simple_path(
		actor.global_transform.origin, 
		_snapshot["changed"][_id]["destination"])
	actor.update_path(path)
	
	
func despawn_actor(_id, _snapshot):
	var actor = actor_container.get_node(str(_id))
	actor.queue_free()
	print("Despawned actor id: %s" % _id)
	
	
func spawn_ability(_id, _snapshot):
	var ability = ability_scene.instance()
	ability.configure(_snapshot[_id])
	ability_container.add_child(ability)
	print("Spawned ability id: %s" % _id)
	
