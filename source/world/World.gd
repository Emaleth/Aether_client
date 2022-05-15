extends Node


onready var actor_scene : PackedScene = preload("res://source/actor/Actor.tscn")
onready var ability_scene : PackedScene 
onready var camera_scene : PackedScene = preload("res://source/camera_rig/CameraRig.tscn") 

onready var actor_container : Node = $Containers/Actors
onready var navigation : Navigation = $Navigation

func _ready() -> void:
	Variables.world = self
	
	
func spawn_actors(_data : Dictionary):
	var actor = actor_scene.instance()
	actor.configure(_data)
	actor_container.add_child(actor)
	if _data.keys()[0] == get_tree().get_network_unique_id():
#		actor.camera_anchor.add_child(camera_scene.instance())
		add_child(camera_scene.instance())


func move_actors(_data : Array):
	for i in _data.size():
		var actor = actor_container.get_node(str(_data[i][0]))
		var path = navigation.get_simple_path(actor.global_transform.origin, _data[i][1])
		actor.update_path(path)
	
	
func despawn_actors(_data : Dictionary):
	pass
	
	
func spawn_abilities(_data : Dictionary):
	pass


func instance_camera():
	add_child(camera_scene.instance())
	


