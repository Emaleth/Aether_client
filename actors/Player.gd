extends "res://actors/Actor.gd"

onready var minimap_camera_remote_transform : RemoteTransform = $MiniMapCameraRT
onready var camera_rig = $CameraRig


func _ready() -> void:
	
#	gui = $GUI
#	statistics.name = "Emaleth"
#	statistics.race = "Necromorph"
#	statistics.guild = "Empire"
#	statistics.level = "69"
#	statistics.title = "Ancient God"
#	conf()
	$GUI.configure_minimap(minimap_camera_remote_transform)
	connect("update_casting_bar", $GUI, "configure_casting_bar")
#	gui.configure_resources_panel(resources)
#	connect("update_resources", gui, "update_resources_panel")
#	load_eq()
	anim_player = $DEBUG_AnimationPlayer
#	gui.configure_inv(self)
#	Server.connect("player_inventory_returned", gui, "configure_inv")
#	Server.fetch_player_inventory()
#	gui.configure_eq(self)
#	connect("update_equipment", gui, "configure_eq", [self])
#	gui.configure_quickbar(self)
#	connect("update_quickbar", gui, "configure_quickbar", [self])
#	gui.configure_spellbook(self)
#	connect("update_spellbook", gui, "configure_spellbook", [self])
	
func _process(_delta: float) -> void:
	get_input()

func get_input():
	direction = Vector3.ZERO
	direction += (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")) * transform.basis.z
	direction += (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * transform.basis.x
	direction = direction.normalized()
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jumping = true
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			if abs(event.relative.x) > .1: 
				rotate_y(-event.relative.x * 0.005)
		
func get_single_target():
	var enemy
	vision_ray.look_at(camera_rig.get_point(), Vector3.UP)
	vision_ray.force_raycast_update()
	if vision_ray.get_collider() is KinematicBody:
		enemy = vision_ray.get_collider()
	else:
		enemy = null
	return enemy

#func get_invetory(data):
#	inventory = data
#	emit_signal("update_inventory")
