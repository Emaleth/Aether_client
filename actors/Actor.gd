extends KinematicBody

enum STATE {IDLE, RUN, JUMP, FALL, DIE}

var target_list = []

var statistics : Dictionary = {
	"name" : "",
	"guild" : "",
	"title" : "",
	"level" : "",
	"speed" : 7,
	"jump_force" : 12, 
	"acceleration" : 15,
	"deceleration" : 10
}

var attributes = {
	"points" : 20,
	"base" : {
		"STR" : 10,
		"DEX" : 10,
		"CONST" : 10,
		"INT" : 10,
		"WIS" : 10
	},
	"player" : {},
	"equipment" : {},
	"effects" : {},
	"total" : {}
}

var resources : Dictionary = {
	"health" : {
		"maximum" : null,
		"current" : null
	},
	"mana" : {
		"maximum" : null,
		"current" : null
	},
	"stamina" : {
		"maximum" : null,
		"current" : null
	}
}
	
var equipment_slots : Dictionary = {
	"head" : [],
	"hands" : [],
	"feet" : [],
	"upper_body" : [],
	"lower_body" : [],
	"cape" : [],
	"belt" : [],
	"shoulders" : [],
	"necklace" : [],
	"ring_1" : [],
	"ring_2" : [],
	"earring_1" : [],
	"earring_2" : [],
	"melee_weapon_1" : [],
	"melee_weapon_2" : [],
	"ranged_weapon" : [],
	"amulet_1" : [],
	"amulet_2" : [],
	"amulet_3" : []
}

var equipment : Dictionary = {}
var inventory : Dictionary = {}
var quickbar : Dictionary = {}
var lootable : Dictionary = {}
var spellbook : Dictionary = {}

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
var enemy = null
var attacking = false

var inv_slot_num = 80
var skill_bar_slot_num = 10
var gcd_used = 0

onready var gravity = ProjectSettings.get("physics/3d/default_gravity")
onready var anim_player : AnimationPlayer
onready var target_area : Area = $TargetArea
onready var vision_ray = $VisionRay
onready var hit_num = preload("res://gui/floating_text/FloatingText.tscn")
onready var name_plate = $NamePlate
onready var rotation_tween : Tween = $RotationTween

signal update_target_ui
signal update_resources
signal update_inventory
signal update_equipment
signal update_quickbar
signal update_spellbook
signal update_stats
signal update_casting_bar
signal finished_casting


func _ready() -> void:
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
#			anim_player.play("idle")
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
#			anim_player.play("run_forward")
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
	make_inventory_construct()
	make_quickbar_construct()
	make_equipment_construct()
	make_attributes_construct()
	make_spellbook_construct()
	remake_equipment_slots_construct()
	# CALCULATE ATTRIBUTES
	calculate_total_attributes()
	# RESTART PROCESSING
	set_process(true)
	set_physics_process(true)
	# CONF HUD
	name_plate.conf(statistics, resources.health)
	connect("update_resources", name_plate, "upd")
	
func modify_resource(resource : String, amount : float, new_max = null) -> void:
	if state != STATE.DIE:
		if new_max != null:
			resources[resource].maximum = new_max
			if resources[resource].current == null or resources[resource].current > new_max:
				resources[resource].current = new_max
		resources[resource].current += amount
		emit_signal("update_resources", resources)
		if resource == "health":
			if amount == 0:
				return
			var h = hit_num.instance()
			get_tree().root.add_child(h)
			h.global_transform.origin = global_transform.origin + Vector3(0, 2.5, 0)
			h.conf(amount, Color.red)
	
func hide_from_minimap_camera(mesh):
	mesh.set_layer_mask_bit(1, false)
	mesh.set_layer_mask_bit(2, false) 

func _on_AttackArea_body_entered(body: Node) -> void:
	if body is KinematicBody:
		if body != self:
			target_list.append(body)

func _on_AttackArea_body_exited(body: Node) -> void:
	if body is KinematicBody:
		if body == enemy:
			enemy = null
			emit_signal("update_target_ui", enemy)
		target_list.erase(body)

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

func make_inventory_construct():
	for i in inv_slot_num:
		var slot_construct = {"item" : null,
							"quantity" : 0,
							"use_time" : 0}
		inventory[i] = slot_construct
							
func make_quickbar_construct():
	for i in skill_bar_slot_num:
		var slot_construct = {"item" : null,
							"quantity" : 0,
							"use_time" : 0}
		quickbar[i] = slot_construct
		
func make_spellbook_construct():
	var index = 0
	for i in DB.spell_db:
		if DB.spell_db.get(i).TYPE != "ITEM":
			spellbook[index] = {"item" : i,
							"quantity" : 1,
							"use_time" : 0}
			index += 1
		
func make_equipment_construct():
	for i in equipment_slots:
		var slot_construct = {"item" : null,
							"quantity" : 0,
							"use_time" : 0}
		equipment[i] = slot_construct
	
func remake_equipment_slots_construct():
	for i in equipment_slots:
		var slot_construct = {"bone" : equipment_slots[i],
							"slot" : []}
		equipment_slots[i] = slot_construct

func make_attributes_construct():
	for a in attributes.base:
		for t in attributes:
			if t != "points" and t != "base":
				attributes.get(t)[a] = 0 
	
func move_item(source_slot = [], target_slot = []):
	var temp_source_slot = source_slot[0].get(source_slot[1]).get(source_slot[2])
	var temp_target_slot = get(target_slot[1]).get(target_slot[2])
	
	if target_slot[1] == "spellbook":
		return
	if source_slot[1] == "spellbook" and target_slot[1] != "quickbar":
		return
	if source_slot[1] == "quickbar":
		if target_slot[1] == "quickbar":
			target_slot[0].get(target_slot[1])[target_slot[2]] = temp_source_slot
			source_slot[0].get(source_slot[1])[source_slot[2]] = temp_target_slot
		else:
			source_slot[0].get(source_slot[1])[source_slot[2]] = {"item" : null, "quantity" : 0, "use_time" : 0}
			
	if source_slot[1] != "quickbar":
		if target_slot[1] == "quickbar":
			target_slot[0].get(target_slot[1])[target_slot[2]] = temp_source_slot
		elif target_slot[1] == "equipment":
			if match_item_to_slot(target_slot[2], source_slot[0].get(source_slot[1])[source_slot[2]].item) == true:
				if source_slot[0].get(source_slot[1])[source_slot[2]].item == target_slot[0].get(target_slot[1])[target_slot[2]].item:
					if "stackable" in DB.item_db.get(source_slot[0].get(source_slot[1])[source_slot[2]].item).TYPE:
						target_slot[0].get(target_slot[1])[target_slot[2]].quantity += source_slot[0].get(source_slot[1])[source_slot[2]].quantity
						source_slot[0].get(source_slot[1])[source_slot[2]] = {"item" : null, "quantity" : 0, "use_time" : 0}
					else:
						target_slot[0].get(target_slot[1])[target_slot[2]] = temp_source_slot
						source_slot[0].get(source_slot[1])[source_slot[2]] = temp_target_slot
				else:
					target_slot[0].get(target_slot[1])[target_slot[2]] = temp_source_slot
					source_slot[0].get(source_slot[1])[source_slot[2]] = temp_target_slot
		else:
			if source_slot[0].get(source_slot[1])[source_slot[2]].item == target_slot[0].get(target_slot[1])[target_slot[2]].item:
				if "stackable" in DB.item_db.get(source_slot[0].get(source_slot[1])[source_slot[2]].item).TYPE:
					target_slot[0].get(target_slot[1])[target_slot[2]].quantity += source_slot[0].get(source_slot[1])[source_slot[2]].quantity
					source_slot[0].get(source_slot[1])[source_slot[2]] = {"item" : null, "quantity" : 0, "use_time" : 0}
				else:
					target_slot[0].get(target_slot[1])[target_slot[2]] = temp_source_slot
					source_slot[0].get(source_slot[1])[source_slot[2]] = temp_target_slot
			else:
				target_slot[0].get(target_slot[1])[target_slot[2]] = temp_source_slot
				source_slot[0].get(source_slot[1])[source_slot[2]] = temp_target_slot
	
	if source_slot[1] == "inventory" || target_slot[1] == "inventory":
		emit_signal("update_inventory")
	if source_slot[1] == "equipment" || target_slot[1] == "equipment":
		get_eq_stats()
		emit_signal("update_equipment")
#		load_eq()
	emit_signal("update_quickbar")
	
var using_item = false
func use_item(source_slot):
	if source_slot[1] != "quickbar":
		return
	var item_of_interest = source_slot[0].get(source_slot[1])[source_slot[2]].item
	var last_time_used = source_slot[0].get(source_slot[1])[source_slot[2]].use_time
	if using_item == true:
		return
	if not DB.item_db.get(item_of_interest).SKILL:
		return
	if DB.spell_db.get(DB.item_db.get(item_of_interest).SKILL).PARAMS.COOLDOWN:
		if OS.get_ticks_msec() - last_time_used < float(DB.spell_db.get(DB.item_db.get(item_of_interest).SKILL).PARAMS.COOLDOWN) * 1000 && last_time_used != 0:
			return
		if OS.get_ticks_msec() - last_time_used < float(Global.cd):
			return
	else:
		if OS.get_ticks_msec() - last_time_used < float(Global.cd):
			return
			
	cast_spell(DB.item_db.get(item_of_interest).SKILL)
	if "consumable" in DB.item_db.get(item_of_interest).TYPE:
		source_slot[0].get(source_slot[1])[source_slot[2]].quantity = (source_slot[0].get(source_slot[1])[source_slot[2]].quantity - 1)
	update_usage(item_of_interest, OS.get_ticks_msec())
	
func use_spell(source_slot):
	if source_slot[1] != "quickbar":
		return
	var item_of_interest = source_slot[0].get(source_slot[1])[source_slot[2]].item
	var last_time_used = source_slot[0].get(source_slot[1])[source_slot[2]].use_time
	if using_item == true:
		return
	if DB.spell_db.get(item_of_interest).PARAMS.COOLDOWN:
		if OS.get_ticks_msec() - last_time_used < float(DB.spell_db.get(item_of_interest).PARAMS.COOLDOWN) * 1000 && last_time_used != 0:
			return
		if OS.get_ticks_msec() - last_time_used < float(Global.cd):
			return
	else:
		if OS.get_ticks_msec() - last_time_used < float(Global.cd):
			return
			
	cast_spell(item_of_interest)
	yield(get_tree(),"idle_frame")
	update_usage(item_of_interest, OS.get_ticks_msec())
	
func match_item_to_slot(slot : String, item) -> bool:
	var slot_name = stripper(slot)
#	print(slot)
#	print(slot_name)
#	print(DB.item_db.get(item).TYPE)
	if slot_name in DB.item_db.get(item).TYPE:
		return true
	else:
		return false

func stripper(hot : String) -> String:
	for num in range(0, 9):
		if hot.find_last(str(num)) != -1:
			hot.erase(hot.find(str(num)), 1)
			
	if hot.ends_with("_"):
		if hot.find_last("_") != -1:
			hot.erase(hot.find_last("_"), 1)
			
	return hot
	
	
func split_item(source_slot = [], target_slot = [], q = 0):
	if q == 0:
		return
	if source_slot[1] == "quickbar":
		move_item(source_slot, target_slot)
	if source_slot[1] != "quickbar":
		if target_slot[1] == "quickbar":
			move_item(source_slot, target_slot)
		elif target_slot[1] == "equipment":
			if match_item_to_slot(target_slot[2], source_slot[0].get(source_slot[1])[source_slot[2]].item) == true:
				if source_slot[0].get(source_slot[1])[source_slot[2]].item == target_slot[0].get(target_slot[1])[target_slot[2]].item:
					if "stackable" in DB.item_db.get(source_slot[0].get(source_slot[1])[source_slot[2]].item).TYPE:
						target_slot[0].get(target_slot[1])[target_slot[2]].quantity += q
						if source_slot[0].get(source_slot[1])[source_slot[2]].quantity - q > 0:
							source_slot[0].get(source_slot[1])[source_slot[2]].quantity -= q
						else:
							source_slot[0].get(source_slot[1])[source_slot[2]] = {"item" : null, "quantity" : 0, "use_time" : 0}
					else:
						move_item(source_slot, target_slot)
				elif target_slot[0].get(target_slot[1])[target_slot[2]].item == "":
					if "stackable" in DB.item_db.get(source_slot[0].get(source_slot[1])[source_slot[2]].item).TYPE:
						target_slot[0].get(target_slot[1])[target_slot[2]] = source_slot[0].get(source_slot[1])[source_slot[2]].duplicate()
						target_slot[0].get(target_slot[1])[target_slot[2]].quantity = q
						if source_slot[0].get(source_slot[1])[source_slot[2]].quantity - q > 0:
							source_slot[0].get(source_slot[1])[source_slot[2]].quantity -= q
						else:
							source_slot[0].get(source_slot[1])[source_slot[2]] = {"item" : null, "quantity" : 0, "use_time" : 0}
					else:
						move_item(source_slot, target_slot)
		else:
			if source_slot[0].get(source_slot[1])[source_slot[2]].item == target_slot[0].get(target_slot[1])[target_slot[2]].item:
				if "stackable" in DB.item_db.get(source_slot[0].get(source_slot[1])[source_slot[2]].item).TYPE:
					target_slot[0].get(target_slot[1])[target_slot[2]].quantity += q
					if source_slot[0].get(source_slot[1])[source_slot[2]].quantity - q > 0:
						source_slot[0].get(source_slot[1])[source_slot[2]].quantity -= q
					else:
						source_slot[0].get(source_slot[1])[source_slot[2]] = {"item" : null, "quantity" : 0, "use_time" : 0}
				else:
					move_item(source_slot, target_slot)
			elif target_slot[0].get(target_slot[1])[target_slot[2]].item == null:
				if "stackable" in DB.item_db.get(source_slot[0].get(source_slot[1])[source_slot[2]].item).TYPE:
					target_slot[0].get(target_slot[1])[target_slot[2]] = source_slot[0].get(source_slot[1])[source_slot[2]].duplicate()
					target_slot[0].get(target_slot[1])[target_slot[2]].quantity = q
					if source_slot[0].get(source_slot[1])[source_slot[2]].quantity - q > 0:
						source_slot[0].get(source_slot[1])[source_slot[2]].quantity -= q
					else:
						source_slot[0].get(source_slot[1])[source_slot[2]] = {"item" : null, "quantity" : 0, "use_time" : 0}
				else:
					move_item(source_slot, target_slot)
	
	if source_slot[1] == "inventory" || target_slot[1] == "inventory":
		emit_signal("update_inventory")
	if source_slot[1] == "equipment" || target_slot[1] == "equipment":
		emit_signal("update_equipment")
#		load_eq()
	emit_signal("update_quickbar")

func update_usage(used_item, usage_time):
	gcd_used = usage_time
	for e in equipment:
		if equipment.get(e).quantity < 1:
			equipment[e] = {"item" : null, "quantity" : 0, "use_time" : 0}
		elif equipment.get(e).item == used_item:
			equipment.get(e).use_time = usage_time
	for i in inventory:
		if inventory.get(i).quantity < 1:
			inventory[i] = {"item" : null, "quantity" : 0, "use_time" : 0}
		elif inventory.get(i).item == used_item:
			inventory.get(i).use_time = usage_time
	for q in quickbar:
		if quickbar.get(q).quantity < 1:
			quickbar[q] = {"item" : null, "quantity" : 0, "use_time" : 0}
		elif quickbar.get(q).item == used_item:
			quickbar.get(q).use_time = usage_time
	for s in spellbook:
		if spellbook.get(s).quantity < 1:
			spellbook[s] = {"item" : null, "quantity" : 0, "use_time" : 0}
		elif spellbook.get(s).item == used_item:
			spellbook.get(s).use_time = usage_time
	yield(get_tree(), "idle_frame")
	emit_signal("update_quickbar")
	emit_signal("update_inventory")
	emit_signal("update_equipment")
	emit_signal("update_spellbook")
	
func increase_stat(stat):
	if attributes.points > 0:
		attributes.player[stat] += 1
		attributes.points -= 1
		calculate_total_attributes()

func cast_spell(spell):
	for i in DB.spell_db.get(spell).COST:
		if DB.spell_db.get(spell).COST.get(i):
			if resources.get((i).to_lower()).current < float(DB.spell_db.get(spell).COST.get(i)):
				return

	using_item = true
	if DB.spell_db.get(spell).PARAMS.CAST_TIME:
		emit_signal("update_casting_bar", float(DB.spell_db.get(spell).PARAMS.CAST_TIME))
		yield(get_tree().create_timer(float(DB.spell_db.get(spell).PARAMS.CAST_TIME)),"timeout")
	emit_signal("finished_casting", true)
			
	for i in DB.spell_db.get(spell).COST:
		if DB.spell_db.get(spell).COST.get(i):
			resources.get((i).to_lower()).current += float(DB.spell_db.get(spell).COST.get(i))

	var spell_recivers = []
#	match DB.spell_db.get(spell).TYPE:
	if DB.spell_db.get(spell).PARAMS.RANGE == null:
		# SELF
		if DB.spell_db.get(spell).PARAMS.RADIUS == null:
			spell_recivers.append(self)
		# AOE
		else:
			for i in target_area.get_overlapping_bodies():
				if not i in target_list:
					continue
				if global_transform.origin.distance_to(i.global_transform.origin) > float(DB.spell_db.get(spell).PARAMS.RADIUS):
					continue
				vision_ray.cast_to = Vector3(0, 0, -float(DB.spell_db.get(spell).PARAMS.RADIUS))
				vision_ray.look_at(i.global_transform.origin + Vector3(0, 0.9, 0), Vector3.UP)
				vision_ray.force_raycast_update()
				if vision_ray.get_collider() != i:
					continue
				spell_recivers.append(i)
			if enemy:
				spell_recivers.append(enemy)
	else:
		# TARGETED
		if DB.spell_db.get(spell).PARAMS.RADIUS == null:
			if not enemy:
				get_target()
			if enemy:
				if global_transform.origin.distance_to(enemy.global_transform.origin) <= float(DB.spell_db.get(spell).PARAMS.RANGE):
					spell_recivers.append(enemy)
		else:
			# TARGETED AOE
			print("targeted aoe")
			
	for i in spell_recivers:
		for f in DB.spell_db.get(spell).TARGET:
			if DB.spell_db.get(spell).TARGET.get(f):
				i.modify_resource((f).to_lower(), float(DB.spell_db.get(spell).TARGET.get(f)))

	using_item = false
	
func get_target():
	var new_target = target_list.pop_front()
	if new_target:
		if enemy:
			if target_area.overlaps_body(enemy): 
				target_list.append(enemy)
		enemy = new_target
	emit_signal("update_target_ui", enemy)
		
func add_lootable(creature_id, loot):
	lootable[creature_id] = loot

func add_item_to_inventory(new_item, quantity = 1):
	if quantity > 1 and not "stackable" in DB.item_db.get(new_item).TYPE:
		for q in quantity:
			for i in inventory:
				if inventory.get(i).item == null:
					inventory.get(i).item = new_item
					inventory.get(i).quantity = 1
					break
				elif i == inventory.size() - 1:
					print("not enaught inventory space")
					
	else:
		for i in inventory:
			if inventory.get(i).item == null:
				inventory.get(i).item = new_item
				inventory.get(i).quantity = quantity
				break
			elif i == inventory.size() - 1:
				print("not enaught inventory space for stackable")

	emit_signal("update_inventory")
	
func get_eq_stats():
	for i in attributes.equipment:
		attributes.equipment[i] = 0
	for piece in equipment:
		if equipment.get(piece).item:
			if DB.item_db.get(equipment.get(piece).item).ATTRIBUTES == null:
				continue
			for i in DB.item_db.get(equipment.get(piece).item).ATTRIBUTES:
				attributes.equipment[i] += DB.item_db.get(equipment.get(piece).item).ATTRIBUTES.get(i)
	calculate_total_attributes()

func calculate_total_attributes():
	for i in attributes.total:
		attributes.total[i] = 0
	for type in attributes:
		if type != "total" and type != "points":
			for one in attributes.get(type):
				attributes.total[one] += attributes.get(type).get(one)
	modify_resource("health", 0, attributes.total.CONST * 5)
	modify_resource("mana", 0, attributes.total.WIS * 5)
	modify_resource("stamina", 0, attributes.total.DEX * 5)
	emit_signal("update_stats", attributes.total, attributes.points)

func lerped_rotation():
	look_at(enemy.global_transform.origin, Vector3.UP)
	rotation.x = 0
#	var new_basis = (global_transform.looking_at(enemy.global_transform.origin, Vector3.UP)).basis
#
#	rotation_tween.remove_all()
#	rotation_tween.interpolate_property(
#		self, 
#		"global_transform:basis", 
#		global_transform.basis, 
#		new_basis,
#		0.1, 
#		Tween.TRANS_LINEAR, 
#		Tween.EASE_IN
#		)
#	rotation_tween.start()
