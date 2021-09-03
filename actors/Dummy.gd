extends KinematicBody

onready var anim = $Male_Casual/AnimationPlayer


func move_player(new_position, new_rotation):
	transform.origin = new_position
	transform.basis = new_rotation
	 # SET ANIMAION AND ANIMATION FRAME
