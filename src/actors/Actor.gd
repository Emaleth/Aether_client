extends KinematicBody

enum STATE {IDLE, RUN, JUMP, FALL, DIE}

var target_list = []
var statistics : Dictionary = {
	"name" : "",
	"race" : "",
	"guild" : "",
	"title" : "",
	"level" : "",
	"speed" : 7,
	"jump_force" : 12, 
	"acceleration" : 15,
	"deceleration" : 10
}


var animations : Dictionary = {
	"idle" : preload("res://assets/animations/2h_idle.anim"),
	"run" : preload("res://assets/animations/2h_run.anim"),
	"death" : preload("res://assets/animations/2h_death.anim"),
	"sheath" : preload("res://assets/animations/2h_sheath.anim"),
	"slash" : preload("res://assets/animations/2h_slash.anim"),
	"slash2" : preload("res://assets/animations/2h_slash2.anim"),
	"strafe" : preload("res://assets/animations/2h_strafe.anim"),
	"jump" : preload("res://assets/animations/2h_jump.anim")
}

var resources : Dictionary = {
	"health" : {
		"maximum" : 100,
		"current" : 100
	},
	"mana" : {
		"maximum" : 100,
		"current" : 100
	},
	"stamina" : {
		"maximum" : 100,
		"current" : 100
	}
}

var equipment : Dictionary = {
	"mainhand" : {
		"bone" : ["RightHand"],
		"slot" : null,
		"item" : null
	},
	"offhand" : {
		"bone" : ["LeftHand"],
		"slot" : null,
		"item" : null
	},
	"boots" : {
		"bone" : ["LeftFoot", "RightFoot"],
		"slot" : null,
		"item" : null
	},
	"gloves" : {
		"bone" : ["LeftHand", "RightHand"],
		"slot" : null,
		"item" : null
	},
	"torso" : {
		"bone" : ["Spine2"],
		"slot" : null,
		"item" : null
	},
	"helmet" : {
		"bone" : ["Head"],
		"slot" : null,
		"item" : null
	},
	"cape" : {
		"bone" : ["Spine2"],
		"slot" : null,
		"item" : null
	}
}
	
var inventory : Array = []
# INTERNAL WORKING STUFF
var state = null
var model
var velocity = Vector3()
var gravity_vec = Vector3()
var direction = Vector3()
var jumping = false
var falling = false
var rot_direction : int
var turn_speed : float = 3.0
var target = null
var attacking = false

onready var gravity = ProjectSettings.get("physics/3d/default_gravity")
onready var anim_player : AnimationPlayer
onready var attack_area = $AttackArea
onready var attack_ray = $AttackRay
onready var gcd : Timer = $GlobalCoolDown 
onready var hit_num = preload("res://src/hit_number/HitNumber.tscn")

signal target_lost
signal res_mod

func _ready() -> void:
	gcd.connect("timeout", self, "attack")
	gravity *= 3 # gravity multiplier
	# HALT PROCESSING 
	set_process(false)
	set_physics_process(false)
	# SET INITIAL STATE
	state = STATE.IDLE
	attacking = true
	
func _physics_process(delta: float) -> void:
	finite_state_machine(delta)
		
func finite_state_machine(delta: float) -> void:
	match state:
		STATE.IDLE:
			anim_player.play("idle")
			gravity_vec = (get_floor_normal() * -1) * gravity
			velocity = velocity.linear_interpolate(Vector3.ZERO, statistics.deceleration * delta)
			
			if direction != Vector3.ZERO:
				state = STATE.RUN
			if jumping == true:
				state = STATE.JUMP
			if  not is_on_floor():
				state = STATE.FALL
			if resources.health.current <= 0:
				state = STATE.DIE
					
		STATE.RUN:
			anim_player.play("run")
			gravity_vec = (get_floor_normal() * -1) * gravity
			velocity = velocity.linear_interpolate(direction * statistics.speed, statistics.acceleration * delta)
			
			if direction == Vector3.ZERO:
				state = STATE.IDLE
			if jumping == true:
				state = STATE.JUMP
			if not is_on_floor():
				state = STATE.FALL
			if resources.health.current <= 0:
				state = STATE.DIE
			
		STATE.JUMP:
			anim_player.play("jump")
			velocity = velocity.linear_interpolate(direction * statistics.speed, statistics.deceleration * delta)
			if jumping == true:
				gravity_vec = Vector3.UP * statistics.jump_force
				jumping = false
			else:
				gravity_vec += Vector3.DOWN * gravity * delta 
				
			if gravity_vec < Vector3.ZERO:
				state = STATE.FALL
			
		STATE.FALL:
			anim_player.play("idle")
			gravity_vec += Vector3.DOWN * gravity * delta
			velocity = velocity.linear_interpolate(direction * statistics.speed, statistics.deceleration * delta)
			if is_on_floor():
				state = STATE.IDLE
			
		STATE.DIE:
#			anim_player.play("die")
			queue_free()
			gravity_vec = Vector3.DOWN * gravity
			velocity = velocity.linear_interpolate(Vector3.ZERO, statistics.deceleration * delta)
			
			
	rotate_y(delta * sign(rot_direction) * turn_speed)
	move_and_slide(velocity + gravity_vec, Vector3.UP, true)

func conf():
	# GET 3D MODEL
	model = model.instance()
	add_child(model)
	model.rotate_y(deg2rad(180))
	for i in model.get_children():
		if i is MeshInstance:
			hide_from_minimap_camera(i)
	# CREATE BONE ATTACHMENT NODES
	for i in equipment:
		for s in equipment.get(i).bone: 
			equipment.get(i).slot = BoneAttachment.new()
			model.add_child(equipment.get(i).slot)
			equipment.get(i).slot.bone_name = s
	# GET ANIMATION PLAYER
	anim_player = model.find_node("AnimationPlayer")
	# LOAD ANIMATIONS
	for i in animations:
		anim_player.add_animation(i, animations.get(i))
	# CONF HUD
	$NameResHud.conf(statistics, resources)
	# RESTART PROCESSING
	connect("res_mod", $NameResHud, "upd", [resources])
	set_process(true)
	set_physics_process(true)
	
func modify_resource(resource : String, amount : int) -> void:
	resources[resource].current += amount
	emit_signal("res_mod")

func hurt(amount) -> void:
	modify_resource("health", -amount)
	var h = hit_num.instance()
	get_tree().root.add_child(h)
	h.global_transform.origin = global_transform.origin + Vector3(0, 2.5, 0)
	h.conf(amount)
	
func equip_item(item) -> void:
	equipment.mainhand.slot.add_child(item)
	item.rotate_x(deg2rad(-90)) # DEBUG SWORD SPECIFIC, NOT NEEDED OTHERWISE
	item.rotate_y(deg2rad(180)) # DEBUG SWORD SPECIFIC, NOT NEEDED OTHERWISE
	for i in item.get_children():
		if i is MeshInstance:
			hide_from_minimap_camera(i)
	
func hide_from_minimap_camera(mesh):
	mesh.set_layer_mask_bit(0, false)
	mesh.set_layer_mask_bit(2, true)
	
func show_indicator(yay_or_nay : bool):
	if yay_or_nay:
		$TargetIndicator.bounce()
	else:
		$TargetIndicator.halt()

func _on_AttackArea_body_entered(body: Node) -> void:
	if body is KinematicBody:
		if body != self:
			target_list.append(body)

func _on_AttackArea_body_exited(body: Node) -> void:
	if body is KinematicBody:
		if body == target:
			emit_signal("target_lost")
			target = null
		target_list.erase(body)

func attack():
	if attacking == true:
		if target:
			gcd.start(1)
			target.hurt(10)
			modify_resource("mana", -5)
			
