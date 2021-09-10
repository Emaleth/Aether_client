extends KinematicBody

var max_hp
var current_hp
var type
var state


func move_player(new_position, new_rotation):
	transform.origin = new_position
	transform.basis = new_rotation
	 # SET ANIMAION AND ANIMATION FRAME


func set_health(_num):
	pass

func despawn():
	ObjectPool.free_item("dummy", self.get_instance_id())
