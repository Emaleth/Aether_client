extends Node
class_name IKAnimator, "res://assets/icons/class/IKAnimator.svg" 

onready var skeleton_data = {
	"right_leg" : {
		"ik_node" : SkeletonIK.new(),
		"target_node" : Position3D.new(),
		"ray_node" : RayCast.new(),
		"root_bone" : "right_upper_leg",
		"tip_bone" : "right_foot",
		"magnet" : Vector3(0, 0, -2),
		"offset_x" : 0.1,
	},
	"left_leg" : {
		"ik_node" : SkeletonIK.new(),
		"target_node" : Position3D.new(),
		"ray_node" : RayCast.new(),
		"root_bone" : "left_upper_leg",
		"tip_bone" : "left_foot",
		"magnet" : Vector3(0, 0, -2),
		"offset_x" : -0.1
	}
}

var step_lenght : float = 0.75
var step_height : float = 0.2
var skeleton : Skeleton = null
var configured : bool = false
var foot_spreed = 0.1
var time = 0


func configure(_skeleton : Skeleton):
	skeleton = _skeleton
	yield(get_tree(), "idle_frame")
	for i in ["right_leg", "left_leg"]: # CONFIG LEGS
		# test
		skeleton_data[i]["ik_node"].root_bone = skeleton_data[i]["root_bone"]
		skeleton_data[i]["ik_node"].tip_bone = skeleton_data[i]["tip_bone"]
		# ADD NODES TO THE TREE
		get_parent().add_child(skeleton_data[i]["ray_node"])
		skeleton.add_child(skeleton_data[i]["ik_node"])
		skeleton.add_child(skeleton_data[i]["target_node"])
		skeleton_data[i]["target_node"].add_child((load("res://DebugMesh.tscn")).instance())
		yield(get_tree(), "idle_frame")
		# CONFIGURE "Raycast" NODE
		skeleton_data[i]["ray_node"].cast_to = Vector3.DOWN * 5
		skeleton_data[i]["ray_node"].enabled = true
		skeleton_data[i]["ray_node"].transform.origin.x = skeleton_data[i]["offset_x"]
		skeleton_data[i]["target_node"].transform.origin.x = skeleton_data[i]["offset_x"]
		# CONFIGURE "SkeletonIK" NODE
		skeleton_data[i]["ik_node"].override_tip_basis = false 
		skeleton_data[i]["ik_node"].use_magnet = true
		skeleton_data[i]["ik_node"].magnet = skeleton_data[i]["magnet"]
		skeleton_data[i]["ik_node"].target_node = skeleton_data[i]["target_node"].get_path()
		yield(get_tree(), "idle_frame")
		skeleton_data[i]["ik_node"].start()
	configured = true
	
func animate(_velocity):
	if configured == false:
		return
		
	time = wrapf(time + get_process_delta_time(), 0, 1000)
	
	var local_velocity = _velocity.length()
	var local_direction = _velocity.normalized()
	
	var frequency = local_velocity / step_lenght
	var cosine_wave_z = cos(time * frequency) * (step_lenght * local_direction.z)
	var cosine_wave_x = cos(time * frequency) * (step_lenght * local_direction.x)
	var sine_wave = sin(time * frequency) * step_height
	
	var offset_direction = Vector3.FORWARD
	if local_direction.is_normalized():
		offset_direction = local_direction
		
	skeleton.transform.origin.y = abs(sin(time * frequency) * 0.2)
	
	skeleton_data["right_leg"]["ray_node"].transform.origin.z = cosine_wave_z + (foot_spreed * -offset_direction.x)
	skeleton_data["right_leg"]["ray_node"].transform.origin.x = cosine_wave_x + (foot_spreed * abs(offset_direction.z))
	skeleton_data["left_leg"]["ray_node"].transform.origin.z = -cosine_wave_z + (foot_spreed * -offset_direction.x)
	skeleton_data["left_leg"]["ray_node"].transform.origin.x = -cosine_wave_x + (foot_spreed * -abs(offset_direction.z))
	
	skeleton_data["right_leg"]["target_node"].transform.origin.z = skeleton.to_local(skeleton_data["right_leg"]["ray_node"].get_collision_point()).z
	skeleton_data["right_leg"]["target_node"].transform.origin.x = skeleton.to_local(skeleton_data["right_leg"]["ray_node"].get_collision_point()).x
	skeleton_data["left_leg"]["target_node"].transform.origin.z = skeleton.to_local(skeleton_data["left_leg"]["ray_node"].get_collision_point()).z
	skeleton_data["left_leg"]["target_node"].transform.origin.x = skeleton.to_local(skeleton_data["left_leg"]["ray_node"].get_collision_point()).x
	
	skeleton_data["right_leg"]["target_node"].transform.origin.y = max(skeleton.to_local(skeleton_data["right_leg"]["ray_node"].get_collision_point()).y - sine_wave, skeleton.to_local(skeleton_data["right_leg"]["ray_node"].get_collision_point()).y)
	skeleton_data["left_leg"]["target_node"].transform.origin.y = max(skeleton.to_local(skeleton_data["left_leg"]["ray_node"].get_collision_point()).y + sine_wave, skeleton.to_local(skeleton_data["left_leg"]["ray_node"].get_collision_point()).y)
	
