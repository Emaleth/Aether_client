extends SpringArm

var mouse_sensibility : float = 0.005
var mouse_deadzone : float = 0.1

var min_rotation_x : float = deg2rad(-80)
var max_rotation_x : float = deg2rad(80)
var raycast_lenght := 10000

var interaction_range := 100

var target_data := {}
onready var camera = $Camera


func _ready() -> void:
	GlobalVariables.camera_rig = self


func _physics_process(_delta: float) -> void:
	target_data = cast_ray_from_camera_to_mouse_pointer()
	get_input()
	
	
func _unhandled_input(event: InputEvent) -> void:
	if GlobalVariables.user_interface.mode != GlobalVariables.user_interface.COMBAT:
		return
	if event is InputEventMouseMotion:
		rotate_camera_rig(event.relative)


func get_input():
	if GlobalVariables.user_interface.mode != GlobalVariables.user_interface.COMBAT:
		return
	if Input.is_action_pressed("primary_action"):
		var body = target_data.collider if target_data.size() > 0 else null
		if body:
			interact(body)
			
			
func rotate_camera_rig(_amount : Vector2) -> void:
	if _amount.length() <= mouse_deadzone:
		return
	rotation.x -= _amount.y * mouse_sensibility
	rotation.x = clamp(rotation.x, min_rotation_x, max_rotation_x)


func cast_ray_from_camera_to_mouse_pointer() -> Dictionary:
	var space_state = get_world().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * raycast_lenght
	var intersection = space_state.intersect_ray(from, to)

	return intersection


func interact(_body):
	if _body.is_in_group("shop"):
		if Input.is_action_just_pressed("primary_action"):
			if _body.global_transform.origin.distance_squared_to(GlobalVariables.player_actor.global_transform.origin) < interaction_range:
				GlobalVariables.user_interface.conf_shop(GlobalVariables.get_npc_data(_body.shop_id)[1]["goods"], int(_body.name))
	elif _body.is_in_group("crafting_station"):
		if Input.is_action_just_pressed("primary_action"):
			if _body.global_transform.origin.distance_squared_to(GlobalVariables.player_actor.global_transform.origin) < interaction_range:
				GlobalVariables.user_interface.set_mode(GlobalVariables.user_interface.CRAFTING)
	elif _body.is_in_group("resource"):
		if Input.is_action_just_pressed("primary_action"):
			if _body.global_transform.origin.distance_squared_to(GlobalVariables.player_actor.global_transform.origin) < interaction_range:
				Server.request_material_gather(_body.name)
	elif _body.is_in_group("loot"):
		if Input.is_action_just_pressed("primary_action"):
			if _body.global_transform.origin.distance_squared_to(GlobalVariables.player_actor.global_transform.origin) < interaction_range:
				Server.request_loot_data(int(_body.name))
	else:
		shoot()
		

func shoot():
	var weapon = GlobalVariables.equipment_data["weapon"]
	if not weapon:
		return
	var weapon_data = GlobalVariables.get_item_data(weapon["item"])
	var w_cd : float = 1.0 / weapon_data[1]["rof"] * 1000
	var current_time = Server.client_clock
	if current_time - weapon["used"] < w_cd:
		return
	weapon["used"] = current_time
	Server.send_weapon_use_request(GlobalVariables.player_actor.get_node("weapon_pivot").global_transform)
	GlobalVariables.player_actor.weapon_pivot.get_node("MeshInstance").shoot()
