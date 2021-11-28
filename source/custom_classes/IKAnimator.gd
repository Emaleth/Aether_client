class_name IKAnimator, "res://assets/icons/class/IKAnimator.svg" 
extends Spatial

export(NodePath) var spine_target
export(NodePath) var right_arm_target
export(NodePath) var left_arm_target
onready var right_leg_target = $RightLegTarget
onready var left_leg_target = $LeftLegTarget

export(float) var foot_offset

var step_lenght : float = 0.75
var step_height : float = 0.5
var skeleton : Skeleton = null
var configured : bool = false
var foot_spreed = 0.1
var time = 0


func _ready() -> void:
	$human/Armature/Skeleton/LeftLegIK.start()
	$human/Armature/Skeleton/RightLegIK.start()
	$RLR.transform.origin.x = 0.1
	$LLR.transform.origin.x = -0.1
	configured = true
	
func animate(_velocity):
	if configured == false:
		return
		
	time = wrapf(time + get_process_delta_time(), 0, 1000)
	
	var local_velocity = _velocity.length()
	var local_direction = _velocity.normalized()
	
	var frequency = local_velocity / step_lenght
	var cosine_wave_z = cos(time * frequency) * (step_lenght * local_direction.z)
	var sine_wave = sin(time * frequency) * step_height
		
#	transform.origin.y = abs(sin(time * frequency) * 0.2) - 0.2
	
	$RLR.transform.origin.z = cosine_wave_z
	$LLR.transform.origin.z = -cosine_wave_z

	right_leg_target.transform.origin.z = $RLR.get_collision_point().z
	right_leg_target.transform.origin.x = $RLR.get_collision_point().x
	left_leg_target.transform.origin.z = $LLR.get_collision_point().z
	left_leg_target.transform.origin.x = $LLR.get_collision_point().x
	
	right_leg_target.transform.origin.y = max($RLR.get_collision_point().y - sine_wave, $RLR.get_collision_point().y)
	left_leg_target.transform.origin.y = max($LLR.get_collision_point().y + sine_wave, $LLR.get_collision_point().y)
	
