extends KinematicBody

var speed = 5
var jump_force = 10
var jump_vector = Vector3.UP * jump_force
var gravity = 9.8
var gravity_vec = Vector3.DOWN * gravity

var sensibility : float = 0.005
var deadzone : float = 0.1

onready var camera_rig_scene = preload("res://source/camera_rig/CameraRig.tscn")
onready var camera_position = $CameraPosition
onready var minimap_remote_transform = $MinimapRemoteTransform


func instanciate_camera():
	GlobalVariables.camera_rig = camera_rig_scene.instance()
	camera_position.add_child(GlobalVariables.camera_rig)


func set_minimap_camera_transform(_path):
	minimap_remote_transform.remote_path = _path


func _ready() -> void:
	instanciate_camera()
	
	
func _physics_process(_delta: float) -> void:
	move()

	
func _unhandled_input(event: InputEvent) -> void:
	if not Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		return
	if Input.is_action_just_pressed("primary_action"):
		pass
	if Input.is_action_just_pressed("secondary_action"):
		pass
	if event is InputEventMouseMotion:
		rotate_character(event.relative)

	if Input.is_action_just_pressed("pick_loot"):
		pick_loot()
	if Input.is_action_just_pressed("npc_interact"):
		npc_interact()
		

func get_direction() -> Vector3:
	var direction = Vector3.ZERO
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
		direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		direction = direction.normalized()
	
	return direction
	
	
func move():
	var direction_xform = transform.basis.xform(Vector3(get_direction() * speed))
	move_and_slide_with_snap(direction_xform, Vector3.DOWN, Vector3.UP)
	
	
func rotate_character(_amount : Vector2) -> void:
	if _amount.length() <= deadzone:
		return
	rotation.y -= _amount.x * sensibility
	rotation.y = wrapf(rotation.y, -180, 180)


func pick_loot():
	var pickable_loot = $LootDetector.get_overlapping_bodies()
	if pickable_loot.size() != 0:
		var nearest_loot = null
		var closest_distance = null
		for i in pickable_loot:
			if closest_distance == null:
				nearest_loot = i
				closest_distance = i.global_transform.origin.distance_to(global_transform.origin)
			elif i.global_transform.origin.distance_to(global_transform.origin) < closest_distance:
				nearest_loot = i
				closest_distance = i.global_transform.origin.distance_to(global_transform.origin)
		Server.request_interaction("loot", nearest_loot.get_parent().name)


func npc_interact():
	var interact_with = $LootDetector.get_overlapping_bodies()
	if interact_with.size() != 0:
		var nearest_npc = null
		var closest_distance = null
		for i in interact_with:
			if closest_distance == null:
				nearest_npc = i
				closest_distance = i.global_transform.origin.distance_to(global_transform.origin)
			elif i.global_transform.origin.distance_to(global_transform.origin) < closest_distance:
				nearest_npc = i
				closest_distance = i.global_transform.origin.distance_to(global_transform.origin)
		Server.request_interaction("shop", nearest_npc.get_parent().name)
