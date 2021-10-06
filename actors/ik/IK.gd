extends Node

export(float) var model_height = 1.8

onready var skeleton_data = {
	"right_leg" : {
		"ik_node" : SkeletonIK.new(),
		"target_node" : Position3D.new(),
		"ray_node" : RayCast.new(),
		"tween_node" : Tween.new(),
		"root_bone" : "right_upper_leg",
		"tip_bone" : "right_foot",
		"magnet" : Vector3(0, 0, -2),
		"offset_x" : 0.15
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

var step_time = 0.2
var step_lenght = model_height * 0.43
var step_height = model_height * 0.2
var skeleton : Skeleton = null
var current_leg = "right_leg"
var configured = false


func configure(_skeleton : Skeleton):
	skeleton = _skeleton
	yield(get_tree(), "idle_frame")
	for i in skeleton_data.keys():
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
#		skeleton_data[i]["ray_node"].transform.origin.z = -0.4
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
	
func run_animation(_velocity):
	if not configured == true:
		return
	if not skeleton_data[current_leg]["tween_node"].is_active():
		if skeleton_data[current_leg]["target_node"].global_transform.origin.distance_to(skeleton_data[current_leg]["ray_node"].get_collision_point()) > step_lenght:
			# MOVE ON X AXIS
			skeleton_data[current_leg]["tween_node"].interpolate_property(
				skeleton_data[current_leg]["target_node"],
				"global_transform:origin:x",
				skeleton_data[current_leg]["target_node"].global_transform.origin.x,
				skeleton_data[current_leg]["ray_node"].get_collision_point().x,
				step_time,
				Tween.TRANS_LINEAR,
				Tween.EASE_IN
			)
			# MOVE ON Y AXIS (UP)
			skeleton_data[current_leg]["tween_node"].interpolate_property(
				skeleton_data[current_leg]["target_node"],
				"global_transform:origin:y",
				skeleton_data[current_leg]["target_node"].global_transform.origin.y,
				skeleton_data[current_leg]["ray_node"].get_collision_point().y + step_height,
				step_time / 5,
				Tween.TRANS_CIRC,
				Tween.EASE_IN_OUT
			)
			# MOVE ON Y AXIS (DOWN)
			skeleton_data[current_leg]["tween_node"].interpolate_property(
				skeleton_data[current_leg]["target_node"],
				"global_transform:origin:y",
				skeleton_data[current_leg]["target_node"].global_transform.origin.y,
				skeleton_data[current_leg]["ray_node"].get_collision_point().y,
				step_time / 5,
				Tween.TRANS_LINEAR,
				Tween.EASE_IN,
				(step_time / 5) * 4
			)
			# MOVE ON Z AXIS
			skeleton_data[current_leg]["tween_node"].interpolate_property(
				skeleton_data[current_leg]["target_node"],
				"global_transform:origin:z",
				skeleton_data[current_leg]["target_node"].global_transform.origin.z,
				skeleton_data[current_leg]["ray_node"].get_collision_point().z,
				step_time,
				Tween.TRANS_LINEAR,
				Tween.EASE_IN
			)
			
			skeleton_data[current_leg]["tween_node"].start()
			yield(get_tree().create_timer((step_time / 5) * 2), "timeout")

			if current_leg == "right_leg":
				current_leg = "left_leg"
			elif current_leg == "left_leg":
				current_leg = "right_leg"

func idle_animation():
	if not configured == true:
		return
	if not skeleton_data[current_leg]["tween_node"].is_active():
		if skeleton_data[current_leg]["target_node"].global_transform.origin.distance_to(skeleton_data[current_leg]["ray_node"].get_collision_point()) > 0.1:
			# MOVE ON X AXIS
			skeleton_data[current_leg]["tween_node"].interpolate_property(
				skeleton_data[current_leg]["target_node"],
				"global_transform:origin:x",
				skeleton_data[current_leg]["target_node"].global_transform.origin.x,
				skeleton_data[current_leg]["ray_node"].get_collision_point().x,
				step_time,
				Tween.TRANS_LINEAR,
				Tween.EASE_IN
			)
			# MOVE ON Y AXIS (UP)
			skeleton_data[current_leg]["tween_node"].interpolate_property(
				skeleton_data[current_leg]["target_node"],
				"global_transform:origin:y",
				skeleton_data[current_leg]["target_node"].global_transform.origin.y,
				skeleton_data[current_leg]["ray_node"].get_collision_point().y + step_height,
				step_time / 5,
				Tween.TRANS_CIRC,
				Tween.EASE_IN_OUT
			)
			# MOVE ON Y AXIS (DOWN)
			skeleton_data[current_leg]["tween_node"].interpolate_property(
				skeleton_data[current_leg]["target_node"],
				"global_transform:origin:y",
				skeleton_data[current_leg]["target_node"].global_transform.origin.y,
				skeleton_data[current_leg]["ray_node"].get_collision_point().y,
				step_time / 5,
				Tween.TRANS_LINEAR,
				Tween.EASE_IN,
				(step_time / 5) * 4
			)
			# MOVE ON Z AXIS
			skeleton_data[current_leg]["tween_node"].interpolate_property(
				skeleton_data[current_leg]["target_node"],
				"global_transform:origin:z",
				skeleton_data[current_leg]["target_node"].global_transform.origin.z,
				skeleton_data[current_leg]["ray_node"].get_collision_point().z,
				step_time,
				Tween.TRANS_LINEAR,
				Tween.EASE_IN
			)
			
			skeleton_data[current_leg]["tween_node"].start()
			yield(get_tree().create_timer((step_time / 5) * 2), "timeout")

			if current_leg == "right_leg":
				current_leg = "left_leg"
			elif current_leg == "left_leg":
				current_leg = "right_leg"
