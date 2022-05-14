extends SpringArm

const MAX_ZOOM : int = 100
const MIN_ZOOM : int = 5
var raycast_lenght := 1000

onready var camera = $Camera


func _ready() -> void:
	Variables.camera_rig = self


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("rotate_camera"):
		if event is InputEventMouseMotion:
			rotate_camera_rig(event.relative)
	if Input.is_action_just_pressed("move"):
		move_to_position()
	if Input.is_action_just_pressed("zoom_in"):
		spring_length = max(MIN_ZOOM, spring_length - 1)
	if Input.is_action_just_pressed("zoom_out"):
		spring_length = min(MAX_ZOOM, spring_length + 1)


func rotate_camera_rig(_amount : Vector2) -> void:
	# ROTATE CAMERA
	# check if mouse motion is over deadzone amount
	if _amount.length() <= Settings.mouse_deadzone:
		return

	# horizontal rotation
	rotation.y -= _amount.x * Settings.mouse_sensibility
	rotation.y = wrapf(rotation.y, deg2rad(-180), deg2rad(180))

	# vertical rotation
	rotation.x -= _amount.y * Settings.mouse_sensibility
	rotation.x = clamp(rotation.x, deg2rad(-80), deg2rad(15))


func cast_ray_from_camera_to_mouse_pointer() -> Dictionary:
	# CAMERA -> MOUSE RAYCAST
	var space_state = get_world().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * raycast_lenght
	var intersection = space_state.intersect_ray(from, to)

	return intersection.position


func move_to_position() -> void:
	var position = cast_ray_from_camera_to_mouse_pointer()
	Server.request_move(position)








#
#func interact(_body) -> void:
#	if _body.is_in_group("shop"):
#		if Input.is_action_just_pressed("primary_action"):
#			if _body.global_transform.origin.distance_squared_to(GlobalVariables.player_actor.global_transform.origin) < interaction_range:
#				GlobalVariables.user_interface.conf_shop(GlobalVariables.get_npc_data(_body.shop_id)[1]["goods"], int(_body.name))
#				return
#
#	if _body.is_in_group("crafting_station"):
#		if Input.is_action_just_pressed("primary_action"):
#			if _body.global_transform.origin.distance_squared_to(GlobalVariables.player_actor.global_transform.origin) < interaction_range:
#				GlobalVariables.user_interface.set_mode(GlobalVariables.user_interface.CRAFTING)
#				return
#
#	if _body.is_in_group("resource"):
#		if Input.is_action_just_pressed("primary_action"):
#			if _body.global_transform.origin.distance_squared_to(GlobalVariables.player_actor.global_transform.origin) < interaction_range:
#				Server.request_material_gather(_body.name)
#				return
#
#	if _body.is_in_group("loot"):
#		if Input.is_action_just_pressed("primary_action"):
#			if _body.global_transform.origin.distance_squared_to(GlobalVariables.player_actor.global_transform.origin) < interaction_range:
#				Server.request_loot_data(int(_body.name))
#				return
