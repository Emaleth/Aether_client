extends Node

export(float) var model_height = 1.8
export(float) var step_lenght = 0.75
export(float) var step_time = 0.2

var step_height = model_height / 4

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
		"offset_z" : -0.7
	},
	"left_leg" : {
		"ik_node" : SkeletonIK.new(),
		"target_node" : Position3D.new(),
		"ray_node" : RayCast.new(),
		"tween_node" : Tween.new(),
		"root_bone" : "left_upper_leg",
		"tip_bone" : "left_foot",
		"magnet" : Vector3(0, 0, -2),
		"offset_x" : -0.15,
		"offset_z" : -0.7
	}
}

var skeleton : Skeleton = null
var next_leg = "right_leg"
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
		skeleton_data[i]["ray_node"].transform.origin.z = skeleton_data[i]["offset_z"]
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
	if not configured == true:
		return
	match next_leg:
		"right_leg":
			step_animation("right_leg", "left_leg")
		"left_leg":
			step_animation("left_leg", "right_leg")
			
func step_animation(_current, _next):
	if not skeleton_data[_current]["tween_node"].is_active():
		if skeleton_data[_current]["target_node"].global_transform.origin.distance_to(skeleton_data[_current]["ray_node"].get_collision_point()) > step_lenght:
			# HORIZONTAL
			skeleton_data[_current]["tween_node"].interpolate_property(
				skeleton_data[_current]["target_node"],
				"global_transform:origin:x",
				skeleton_data[_current]["target_node"].global_transform.origin.x,
				skeleton_data[_current]["ray_node"].get_collision_point().x,
				step_time,
				Tween.TRANS_LINEAR,
				Tween.EASE_IN
			)
			skeleton_data[_current]["tween_node"].interpolate_property(
				skeleton_data[_current]["target_node"],
				"global_transform:origin:z",
				skeleton_data[_current]["target_node"].global_transform.origin.z,
				skeleton_data[_current]["ray_node"].get_collision_point().z,
				step_time,
				Tween.TRANS_LINEAR,
				Tween.EASE_IN
			)
			# VERTICAL UP
			skeleton_data[_current]["tween_node"].interpolate_property(
				skeleton_data[_current]["target_node"],
				"global_transform:origin:y",
				skeleton_data[_current]["target_node"].global_transform.origin.y,
				skeleton_data[_current]["ray_node"].get_collision_point().y + step_height,
				step_time / 5,
				Tween.TRANS_CIRC,
				Tween.EASE_IN_OUT
			)
			# VERTICAL DOWN
			skeleton_data[_current]["tween_node"].interpolate_property(
				skeleton_data[_current]["target_node"],
				"global_transform:origin:y",
				skeleton_data[_current]["target_node"].global_transform.origin.y,
				skeleton_data[_current]["ray_node"].get_collision_point().y,
				step_time / 5,
				Tween.TRANS_LINEAR,
				Tween.EASE_IN,
				(step_time / 5) * 4
			)
			skeleton_data[_current]["tween_node"].start()
			yield(get_tree().create_timer((step_time / 5) * 2), "timeout")
			next_leg = _next

