extends Node


onready var actor_scene : PackedScene = preload("res://source/actor/Actor.tscn")
onready var ability_scene : PackedScene 
onready var camera_scene : PackedScene = preload("res://source/camera_rig/CameraRig.tscn") 

onready var actor_container : Node = $Containers/Actors
onready var navigation : Navigation = $Navigation


func _ready() -> void:
	Variables.world = self
	
	
#func spawn_actors(_data : Dictionary):
#	var actor = actor_scene.instance()
#	actor.configure(_data)
#	actor_container.add_child(actor)
#	if _data.keys()[0] == get_tree().get_network_unique_id():
#		actor.bind_camera($CameraRig.get_path())
#
#
#func move_actors(_data : Array):
#	for i in _data.size():
#		var actor = actor_container.get_node(str(_data[i][0]))
#		var path = navigation.get_simple_path(actor.global_transform.origin, _data[i][1])
#		actor.update_path(path)
	
	
func despawn_actors(_data : Dictionary):
	pass
	
	
func spawn_abilities(_data : Dictionary):
	pass


func instance_camera():
	add_child(camera_scene.instance())
	
	
remote func recive_actor_delta_snapshot(_snapshot : Dictionary):
	process_actor_delta_snapshot(_snapshot)
	
	
func process_actor_delta_snapshot(_snapshot):
	for i in _snapshot["spawned"].keys():
		var actor = actor_scene.instance()
		actor.name = str(i)
		actor.configure(_snapshot["spawned"][i])
		actor_container.add_child(actor, true)
		if i == get_tree().get_network_unique_id():
			actor.bind_camera($CameraRig.get_path())
	
	for i in _snapshot["changed"].keys():
		var actor = actor_container.get_node(str(i))
		var path = navigation.get_simple_path(actor.global_transform.origin, _snapshot["changed"][i]["destination"])
		actor.update_path(path)

#	for i in _snapshot["despawned"].keyes():
			
#func draw_path(path_array):
#	var im = get_node("Draw")
#	im.set_material_override(m)
#	im.clear()
#	im.begin(Mesh.PRIMITIVE_POINTS, null)
#	im.add_vertex(path_array[0])
#	im.add_vertex(path_array[path_array.size() - 1])
#	im.end()
#	im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
#	for x in path:
#		im.add_vertex(x)
#	im.end()

