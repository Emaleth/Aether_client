extends Node

var container = self


onready var character_scene = preload("res://source/actor/character/Character.tscn")
onready var interface_scene = preload("res://source/ui/UI.tscn")


func _physics_process(_delta: float) -> void:
	send_player_state()


func spawn_character():
	GlobalVariables.player_actor = character_scene.instance()
	container.add_child(GlobalVariables.player_actor)
	GlobalVariables.user_interface = interface_scene.instance()
	container.add_child(GlobalVariables.user_interface)
	GlobalVariables.player_actor.global_transform.origin = Vector3(0, 8.08, 0)


var frame_index = 0
func send_player_state():
	if GlobalVariables.player_actor:
		frame_index += 1
		if frame_index >= 3:
			Server.send_player_state(
					GlobalVariables.player_actor.global_transform)#,
#					GlobalVariables.player_actor.get_node("gun").global_transform)
			frame_index = 0
