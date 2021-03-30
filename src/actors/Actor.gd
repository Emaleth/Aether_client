extends KinematicBody

enum STANCE {NORMAL, COMBAT}
enum STATE {IDLE, RUN, JUMP, FALL}

var statistics : Dictionary = {
	"speed" : 7,
	"jump" : 9, 
	"acceleration" : 15
}


var animations = {
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
	"max_health" : 100,
	"health" : 100,
	"mana" : 100,
	"max_mana" : 100,
	"stamina" : 100,
	"max_stamina" : 100
}

var equipment : Dictionary = {
	"mainhand" : null,
	"offhand" : null,
	"boots" : null,
	"gloves" : null,
	"torso" : null,
	"helmet" : null,
	"cape" : null
}
	
var inventory : Array = []
# INTERNAL WORKING STUFF
var model : PackedScene
var velocity = Vector3()
var gravity_vec = Vector3()
var direction = Vector3()
var rot_direction : int
var gui : CanvasLayer
var turn_speed : float = 3.0
var weight = 3

onready var gravity = ProjectSettings.get("physics/3d/default_gravity")
onready var anim_player : AnimationPlayer


func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	
func _physics_process(delta: float) -> void:
	rotate_me(delta)
	move_and_slide(calculate_velocity(delta) + calculate_gravity(delta), Vector3.UP)
	if anim_player: # FIXME (rework as to not call in process if possible)
		anim_fsm()
		
func conf():
	var m  = model.instance()
	add_child(m)
	m.rotate_y(deg2rad(180))
	anim_player = m.find_node("AnimationPlayer")
	load_animations()
	set_process(true)
	set_physics_process(true)
	
func load_animations() -> void:
	for i in animations:
		anim_player.add_animation(i, animations.get(i))

func modify_resource(resource : String, amount : int) -> void:
	resources[resource] += amount

func hurt(amount) -> void:
	modify_resource("health", amount)

func calculate_velocity(delta):
	velocity = velocity.linear_interpolate(direction * statistics.speed, statistics.acceleration * delta)
	direction = Vector3.ZERO
	return velocity

func anim_fsm() -> void:
	if velocity.z < -0.1:
		anim_player.play("run")
	elif velocity.z > 0.1:
		anim_player.play_backwards("run")
	elif velocity.x < -0.1:
		anim_player.play("strafe")
	elif velocity.x > 0.1:
		anim_player.play_backwards("strafe")
#	elif gravity_vec.y < -0.1:
#		anim_player.play_backwards("jump")
	elif gravity_vec.y > 0.1:
		anim_player.play("jump")
	else:
		anim_player.play("idle")

func calculate_gravity(delta):
	if is_on_floor():
		gravity_vec = Vector3.DOWN * gravity * delta * weight
	else:
		gravity_vec += Vector3.DOWN * gravity * delta * weight
	if Input.is_action_just_pressed("jump") and is_on_floor():
		gravity_vec = Vector3.UP * statistics.jump
	return gravity_vec

func conf_gui(gui_node : CanvasLayer) -> void:
	gui = gui_node
	gui.get_node("Progress").health_bar.conf(tr("1005"), resources.max_health, resources.health, Color(1, 0, 0, 1))
	gui.get_node("Progress").mana_bar.conf(tr("1007"), resources.max_mana, resources.mana, Color(0, 0, 1, 1))
	gui.get_node("Progress").stamina_bar.conf(tr("1009"), resources.max_stamina, resources.stamina, Color(1, 1, 0, 1))


func rotate_me(delta) -> void:
	rotate_y(delta * sign(rot_direction) * turn_speed)
	rot_direction = 0
