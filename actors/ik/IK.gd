extends Node

export(float) var model_height = 1.8

onready var skeleton_data = {
	"right_leg" : {
		"ik_node" : SkeletonIK.new(),
		"target_node" : Position3D.new(),
		"ray_node" : RayCast.new(),
		"root_bone" : "right_upper_leg",
		"tip_bone" : "right_foot",
		"magnet" : Vector3(0, 0, -2),
		"offset_x" : 0.15,
		"move" : true
	},
	"left_leg" : {
		"ik_node" : SkeletonIK.new(),
		"target_node" : Position3D.new(),
		"ray_node" : RayCast.new(),
		"root_bone" : "left_upper_leg",
		"tip_bone" : "left_foot",
		"magnet" : Vector3(0, 0, -2),
		"offset_x" : -0.15,
		"move" : true
	}
}

var step_lenght = 1 # model_height * 0.43
var step_height = model_height * 0.2
var skeleton : Skeleton = null
var configured = false


func configure(_skeleton : Skeleton):
	skeleton = _skeleton
	yield(get_tree(), "idle_frame")
	for i in skeleton_data.keys():
		# ADD NODES TO THE TREE
		get_parent().add_child(skeleton_data[i]["ray_node"])
		skeleton.add_child(skeleton_data[i]["ik_node"])
		add_child(skeleton_data[i]["target_node"])
		skeleton_data[i]["target_node"].add_child((load("res://DebugMesh.tscn")).instance())
		# CONFIGURE "Raycast" NODE
		skeleton_data[i]["ray_node"].cast_to = Vector3.DOWN * 2
		skeleton_data[i]["ray_node"].enabled = true
		skeleton_data[i]["ray_node"].transform.origin.x = skeleton_data[i]["offset_x"]
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
	
func run_animation(_direction):
	if not configured == true:
		return
		
	for leg in ["right_leg", "left_leg"]:
		skeleton_data[leg]["ray_node"].transform.origin.z = step_lenght * sign(_direction) # FOR NOW SET TO FORWARD, SIDES MORE OR LESS WORK
	
		if skeleton_data[leg]["target_node"].global_transform.origin.distance_to(skeleton_data[leg]["ray_node"].get_collision_point()) > step_lenght:
			skeleton_data[leg]["move"] = true
		elif skeleton_data[leg]["target_node"].global_transform.origin.distance_to(skeleton_data[leg]["ray_node"].get_collision_point()) < 0.1:
			skeleton_data[leg]["move"] = false

		if skeleton_data[leg]["move"] == true:
			skeleton_data[leg]["target_node"].global_transform.origin = skeleton_data[leg]["target_node"].global_transform.origin.linear_interpolate(skeleton_data[leg]["ray_node"].get_collision_point(), 0.5)
	
func idle_animation():
	pass
