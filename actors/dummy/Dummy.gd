extends KinematicBody

onready var anim = $Male_Casual/AnimationPlayer


func move_player(new_position, new_rotation, new_animation = null):
	if transform.origin != new_position:
		transform.origin = new_position
	if transform.basis != new_rotation:
		transform.basis = new_rotation
	if new_animation != null:
		anim.current_animation = new_animation[0]
#		anim.current_animation_position = new_animation[1]

func despawn():
	ObjectPool.free_item("dummy", self)
