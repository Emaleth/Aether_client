extends Node

onready var skeleton_data = {
	"right_leg" : {
		"ik_node" : SkeletonIK.new(),
		"target_node" : Position3D.new(),
		"ray_node" : RayCast.new(),
		"tween_node" : Tween.new(),
		"root_bone" : "right_upper_leg",
		"tip_bone" : "right_foot",
		"magnet" : Vector3(0, 0, -2),
		"offset_x" : 0.15,
	},
	"left_leg" : {
		"ik_node" : SkeletonIK.new(),
		"target_node" : Position3D.new(),
		"ray_node" : RayCast.new(),
		"tween_node" : Tween.new(),
		"root_bone" : "left_upper_leg",
		"tip_bone" : "left_foot",
		"magnet" : Vector3(0, 0, -2),
		"offset_x" : -0.15
	}
}

var step_lenght : float = 1.0
var step_height : float = 0.2
var step_time : float = step_lenght / 2.77
var skeleton : Skeleton = null
var configured : bool = false
var moving = false
onready var center_of_mass : RayCast = RayCast.new()


func configure(_skeleton : Skeleton):
	skeleton = _skeleton
	yield(get_tree(), "idle_frame")
	skeleton.add_child(center_of_mass)
	center_of_mass.cast_to = Vector3.DOWN * 2
	center_of_mass.enabled = true
	for i in ["right_leg", "left_leg"]: # CONFIG LEGS
		# ADD NODES TO THE TREE
		get_parent().add_child(skeleton_data[i]["ray_node"])
		skeleton.add_child(skeleton_data[i]["ik_node"])
		add_child(skeleton_data[i]["target_node"])
		add_child(skeleton_data[i]["tween_node"])
		skeleton_data[i]["target_node"].add_child((load("res://DebugMesh.tscn")).instance())
		# CONFIGURE "Raycast" NODE
		skeleton_data[i]["ray_node"].cast_to = Vector3.DOWN * 2
		skeleton_data[i]["ray_node"].enabled = true
		skeleton_data[i]["ray_node"].transform.origin.x = skeleton_data[i]["offset_x"]
		skeleton_data[i]["ray_node"].transform.origin.z = - step_lenght
		# CONFIGURE INITIAL "Position3D" NODE POSITION
		yield(get_tree(), "idle_frame")
		skeleton_data[i]["target_node"].global_transform.origin = skeleton_data[i]["ray_node"].get_collision_point()
		# CONFIGURE "SkeletonIK" NODE
		skeleton_data[i]["ik_node"].root_bone = skeleton_data[i]["root_bone"]
		skeleton_data[i]["ik_node"].tip_bone = skeleton_data[i]["tip_bone"]
		skeleton_data[i]["ik_node"].override_tip_basis = false 
		skeleton_data[i]["ik_node"].use_magnet = true
		skeleton_data[i]["ik_node"].magnet = skeleton_data[i]["magnet"]
		skeleton_data[i]["ik_node"].target_node = skeleton_data[i]["target_node"].get_path()
		skeleton_data[i]["ik_node"].start()
	configured = true
	
func animation():
	if configured == false or moving == true:
		return
	for i in ["right_leg", "left_leg"]:
		if skeleton_data[i]["tween_node"].is_active():
			return
		center_of_mass.force_raycast_update()
		if center_of_mass.get_collision_point().distance_to(skeleton_data[i]["target_node"].global_transform.origin) >= step_lenght / 2:
			moving = true
			skeleton_data[i]["ray_node"].force_raycast_update()
			skeleton_data[i]["tween_node"].remove_all()
			skeleton_data[i]["tween_node"].interpolate_property(
				skeleton_data[i]["target_node"],
				"global_transform:origin",
				skeleton_data[i]["target_node"].global_transform.origin,
				skeleton_data[i]["ray_node"].get_collision_point(), 
				step_time / 2.0, 
				Tween.TRANS_BOUNCE,
				Tween.EASE_IN
				)
			skeleton_data[i]["tween_node"].start()
			yield(get_tree().create_timer(step_time / 2.0), "timeout")
			moving = false
