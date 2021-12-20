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
	GlobalVariables.player_actor.set_minimap_camera_transform(GlobalVariables.user_interface.get_minimap_pivot_path())


var frame_index = 0
func send_player_state():
	if GlobalVariables.player_actor:
		frame_index += 1
		if frame_index >= 3:
			var pos = GlobalVariables.player_actor.global_transform.origin
			var rot = GlobalVariables.player_actor.global_transform.basis
			var aim = GlobalVariables.camera_rig.cast_ray_from_camera_to_mouse_pointer()["position"]
			Server.send_player_state(pos, rot, aim)
			frame_index = 0
