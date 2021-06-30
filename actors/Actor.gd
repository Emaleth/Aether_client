extends KinematicBody

enum STATE {IDLE, RUN, JUMP, FALL, DIE}

var statistics : Dictionary = {
	"speed" : 7,
	"jump_force" : 12, 
	"acceleration" : 15,
	"deceleration" : 10
}

#var equipment_slots : Dictionary = {
#	"head" : [],
#	"hands" : [],
#	"feet" : [],
#	"upper_body" : [],
#	"lower_body" : [],
#	"cape" : [],
#	"belt" : [],
#	"shoulders" : [],
#	"necklace" : [],
#	"ring_1" : [],
#	"ring_2" : [],
#	"earring_1" : [],
#	"earring_2" : [],
#	"melee_weapon_1" : [],
#	"melee_weapon_2" : [],
#	"ranged_weapon" : [],
#	"amulet_1" : [],
#	"amulet_2" : [],
#	"amulet_3" : []
#}

# INTERNAL WORKING STUFF
var state = null
var model
var velocity = Vector3()
var gravity_vec = Vector3()
var direction = Vector3()
var jumping = false
var falling = false
var rot_direction : float
var turn_speed : float = 3.0

var inv_slot_num = 80
var skill_bar_slot_num = 10
var gcd_used = 0

onready var gravity = ProjectSettings.get("physics/3d/default_gravity")
onready var anim_player : AnimationPlayer
onready var target_area : Area = $TargetArea
onready var vision_ray : RayCast = $VisionRay
onready var hit_num = preload("res://gui/floating_text/FloatingText.tscn")
onready var name_plate = $NamePlate
onready var rotation_tween : Tween = $RotationTween


func _ready() -> void:
	gravity *= 3 # gravity multiplier
	# HALT PROCESSING 
	set_process(false)
	set_physics_process(false)
	# SET INITIAL STATE
	state = STATE.IDLE
#	attacking = true
	
func _physics_process(delta: float) -> void:
	finite_state_machine(delta)
		
func finite_state_machine(delta: float) -> void:
	match state:
		STATE.IDLE:
#			anim_player.play("idle")
			gravity_vec = (get_floor_normal() * -1) * gravity
			velocity = velocity.linear_interpolate(Vector3.ZERO, statistics.deceleration * delta)
			
			if direction != Vector3.ZERO:
				state = STATE.RUN
			if jumping == true:
				state = STATE.JUMP
			if  not is_on_floor():
				state = STATE.FALL
#			if resources.health.current <= 0:
#				state = STATE.DIE
#
		STATE.RUN:
#			anim_player.play("run_forward")
			gravity_vec = (get_floor_normal() * -1) * gravity
			velocity = velocity.linear_interpolate(direction * statistics.speed, statistics.acceleration * delta)
			
			if direction == Vector3.ZERO:
				state = STATE.IDLE
			if jumping == true:
				state = STATE.JUMP
			if not is_on_floor():
				state = STATE.FALL
#			if resources.health.current <= 0:
#				state = STATE.DIE
			
		STATE.JUMP:
#			anim_player.play("jump")
			velocity = velocity.linear_interpolate(direction * statistics.speed, statistics.deceleration * delta)
			if jumping == true:
				gravity_vec = Vector3.UP * statistics.jump_force
				jumping = false
			else:
				gravity_vec += Vector3.DOWN * gravity * delta 
				
			if gravity_vec < Vector3.ZERO:
				state = STATE.FALL
			
		STATE.FALL:
#			anim_player.play("idle")
			gravity_vec += Vector3.DOWN * gravity * delta
			velocity = velocity.linear_interpolate(direction * statistics.speed, statistics.deceleration * delta)
			if is_on_floor():
				state = STATE.IDLE
			
		STATE.DIE:
			gravity_vec = Vector3.DOWN * gravity
			if velocity != Vector3.ZERO:
				velocity = velocity.linear_interpolate(Vector3.ZERO, statistics.deceleration * delta)
			else:
#				anim_player.play("death")
#				yield(anim_player,"animation_finished")
				queue_free()
			
			
	rotate_y(delta * sign(rot_direction) * turn_speed)
	move_and_slide(velocity + gravity_vec, Vector3.UP, true)

func conf():
#	remake_equipment_slots_construct()
	set_process(true)
	set_physics_process(true)

func hide_from_minimap_camera(mesh):
	mesh.set_layer_mask_bit(1, false)
	mesh.set_layer_mask_bit(2, false) 

#func load_eq():
#	for i in equipment:
#	# REMOVE OLD ITEMS FROM MODEL
#		for s in equipment_slots.get(i).slot.size():
#			if equipment_slots.get(i).slot[s].get_child_count() > 0:
#				for k in equipment_slots.get(i).slot[s].get_children():
#					var x = k
#					x.get_parent().remove_child(x)
#					x.queue_free()
#
#		if equipment.get(i).item:
#			for slot in equipment_slots.get(i).slot:
#				var file2Check = File.new()
#				if file2Check.file_exists("res://models/%s.glb" % equipment.get(i).item):
#					var model_path = "res://models/%s.glb" % equipment.get(i).item
#					var item_model = load(model_path)
#					item_model = item_model.instance()
#					item_model.rotate_x(deg2rad(-45)) # DEBUG SWORD SPECIFIC, NOT NEEDED OTHERWISE
#					slot.add_child(item_model)
#
#					for z in item_model.get_children():
#						if z is MeshInstance:
#							hide_from_minimap_camera(z)

#func remake_equipment_slots_construct():
#	for i in equipment_slots:
#		var slot_construct = {"bone" : equipment_slots[i],
#							"slot" : []}
#		equipment_slots[i] = slot_construct

func get_single_target():
	# FUNCTION DEFINED IN CHILD 
	pass
	
func get_group_target():
	var target_list = []
	for i in target_area.get_overlapping_bodies():
		if i is KinematicBody and i != self:
			vision_ray.look_at(i.global_transform.origin + Vector3(0, 0.9, 0), Vector3.UP)
			vision_ray.force_raycast_update()
			if vision_ray.get_collider() == i:
				target_list.append(i)
	return target_list
