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
		"strenght" : 10,
		"dexterity" : 10,
		"constitution" : 10,
		"intelligence" : 10,
		"wisdom" : 10,
		"charisma" : 10
	},
	"player" : {},
	"equipment" : {},
	"effects" : {},
	"total" : {}
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
	"ammunition" : [],
	"ranged_weapon" : [],
	"ring_1" : [],
	"ring_2" : [],
	"earring_1" : [],
	"earring_2" : [],
	"main_hand" : [],
	"off_hand" : [],
	"gathering_tools" : [],
	"amulet_1" : [],
	"amulet_2" : [],
	"amulet_3" : [],
	"back" : []
}

var equipment_slot_type : Dictionary = {
	"head" : ["helmet"],
	"hands" : ["gloves"],
	"feet" : ["boots"],
	"upper_body" : ["armor"],
	"lower_body" : ["legs"],
	"cape" : ["cape"],
	"belt" : ["belt"],
	"shoulders" : ["shoulders"],
	"necklace" : ["necklace"],
	"ammunition" : ["arrow"],
	"ranged_weapon" : ["bow"],
	"ring_1" : ["ring"],
	"ring_2" : ["ring"],
	"earring_1" : ["earring"],
	"earring_2" : ["earring"],
	"main_hand" : ["sword", "longsword", "axe", "dagger", "staff"],
	"off_hand" : ["sword", "axe", "dagger", "shield"],
	"gathering_tools" : ["pickaxe"],
	"amulet_1" : ["orb"],
	"amulet_2" : ["orb"],
	"amulet_3" : ["orb"],
	"back" : ["wings"]
}

var equipment : Dictionary = {}
var inventory : Dictionary = {}
var quickbar : Dictionary = {}
var lootable : Dictionary = {}

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

var inv_slot_num = 70
var skill_bar_slot_num = 20
var gcd_used = 0

onready var gravity = ProjectSettings.get("physics/3d/default_gravity")
onready var anim_player : AnimationPlayer
onready var attack_area = $AttackArea
onready var attack_ray = $AttackRay
onready var hit_num = preload("res://src/hit_number/HitNumber.tscn")
onready var name_plate = $NamePlate


signal target_lost
signal update_resources
signal update_inventory
signal update_equipment
signal update_quickbar
signal update_stats
signal target_ui


func _ready() -> void:
	gravity *= 3 # gravity multiplier
	# HALT PROCESSING 
	set_process(false)
	set_physics_process(false)
	# SET INITIAL STATE
	state = STATE.IDLE
	attacking = true
#	calculate_total_attributes()
	
	
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
	remake_equipment_slots_construct()
	# RESTART PROCESSING
	set_process(true)
	set_physics_process(true)
	# CALCULATE ATTRIBUTES
	calculate_total_attributes()
	# CONF HUD
	name_plate.conf(statistics, resources.health)
	connect("update_resources", name_plate, "upd", [resources.health])
	
func modify_resource(resource : String, amount : float, new_max = null) -> void:
	if state != STATE.DIE:
		if new_max != null:
			resources[resource].maximum = new_max
		resources[resource].current += amount
		emit_signal("update_resources")
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
		if body == enemy:
			emit_signal("target_lost", false)
			enemy = null
		target_list.erase(body)

func load_eq():
	for i in equipment:
	# REMOVE OLD ITEMS FROM MODEL
		for s in equipment_slots.get(i).slot.size():
			if equipment_slots.get(i).slot[s].get_child_count() > 0:
				for k in equipment_slots.get(i).slot[s].get_children():
					var x = k
					x.get_parent().remove_child(x)
					x.queue_free()
		
		if equipment.get(i).item:
			for slot in equipment_slots.get(i).slot:
				var file2Check = File.new()
				if file2Check.file_exists("res://models/%s.glb" % equipment.get(i).item):
					var model_path = "res://models/%s.glb" % equipment.get(i).item
					var item_model = load(model_path)
					item_model = item_model.instance()
					item_model.rotate_x(deg2rad(-45)) # DEBUG SWORD SPECIFIC, NOT NEEDED OTHERWISE
					slot.add_child(item_model)
			
					for z in item_model.get_children():
						if z is MeshInstance:
							hide_from_minimap_camera(z)

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
#	print(attributes)
	
func move_item(source = [], target = []):
	var source_slot = source[0].get(source[1]).get(source[2])
	var target_slot = get(target[1]).get(target[2])
	
	if source[1] == "quickbar":
		if target[1] == "quickbar":
			target[0].get(target[1])[target[2]] = source_slot
			source[0].get(source[1])[source[2]] = target_slot
		else:
			source[0].get(source[1])[source[2]] = {"item" : null, "quantity" : 0, "use_time" : 0}
			
	if source[1] != "quickbar":
		if target[1] == "quickbar":
			target[0].get(target[1])[target[2]] = source_slot
		elif target[1] == "equipment":
			if match_item_to_slot(target[2], source[0].get(source[1])[source[2]].item) == true:
				if source[0].get(source[1])[source[2]].item == target[0].get(target[1])[target[2]].item:
					if DB.item_db.get(source[0].get(source[1])[source[2]].item).STACKABLE:
						target[0].get(target[1])[target[2]].quantity += source[0].get(source[1])[source[2]].quantity
						source[0].get(source[1])[source[2]] = {"item" : null, "quantity" : 0, "use_time" : 0}
					else:
						target[0].get(target[1])[target[2]] = source_slot
						source[0].get(source[1])[source[2]] = target_slot
				else:
					target[0].get(target[1])[target[2]] = source_slot
					source[0].get(source[1])[source[2]] = target_slot
		else:
			if source[0].get(source[1])[source[2]].item == target[0].get(target[1])[target[2]].item:
				if DB.item_db.get(source[0].get(source[1])[source[2]].item).STACKABLE:
					target[0].get(target[1])[target[2]].quantity += source[0].get(source[1])[source[2]].quantity
					source[0].get(source[1])[source[2]] = {"item" : null, "quantity" : 0, "use_time" : 0}
				else:
					target[0].get(target[1])[target[2]] = source_slot
					source[0].get(source[1])[source[2]] = target_slot
			else:
				target[0].get(target[1])[target[2]] = source_slot
				source[0].get(source[1])[source[2]] = target_slot
	
	if source[1] == "inventory" || target[1] == "inventory":
		emit_signal("update_inventory")
	if source[1] == "equipment" || target[1] == "equipment":
		get_eq_stats()
		emit_signal("update_equipment")
		load_eq()
	emit_signal("update_quickbar")

func use_item(source):
	if DB.item_db.get(source[0].get(source[1])[source[2]].item).SKILL:
		var current_time_msec = OS.get_ticks_msec()
		if current_time_msec - source[0].get(source[1])[source[2]].use_time >= float(DB.spell_db.get(DB.item_db.get(source[0].get(source[1])[source[2]].item).SKILL).COOLDOWN) * 1000 || source[0].get(source[1])[source[2]].use_time == 0:
#			print("Current Time: %s" % current_time_msec,
#				" | " + "Last Used Time: %s" % source[0].get(source[1])[source[2]].use_time,
#				" | " + "CD: %s" % (float(DB.item_db.get(source[0].get(source[1])[source[2]].item).CD) * 1000))
			update_usage(source[0].get(source[1])[source[2]].item, current_time_msec)
			cast_spell(DB.item_db.get(source[0].get(source[1])[source[2]].item).SKILL)
			if DB.item_db.get(source[0].get(source[1])[source[2]].item).CONSUMABLE == true:
				source[0].get(source[1])[source[2]].quantity = (source[0].get(source[1])[source[2]].quantity - 1)
				if source[0].get(source[1])[source[2]].quantity <= 0:
					source[0].get(source[1])[source[2]] = {"item" : null, "quantity" : 0, "use_time" : 0}
				
			emit_signal("update_quickbar")
			emit_signal("update_inventory")
			emit_signal("update_equipment")

func match_item_to_slot(slot, item) -> bool:
	if DB.item_db.get(item).SUBTYPE in equipment_slot_type[slot]:
		return true
	else:
		return false
		
func split_item(source = [], target = [], q = 0):
	if q == 0:
		return
#	var source_slot = source[0].get(source[1]).get(source[2])
#	var target_slot = get(target[1]).get(target[2])
	
	if source[1] == "quickbar":
		move_item(source, target)
	if source[1] != "quickbar":
		if target[1] == "quickbar":
			move_item(source, target)
		elif target[1] == "equipment":
			if match_item_to_slot(target[2], source[0].get(source[1])[source[2]].item) == true:
				if source[0].get(source[1])[source[2]].item == target[0].get(target[1])[target[2]].item:
					if DB.item_db.get(source[0].get(source[1])[source[2]].item).STACKABLE:
						target[0].get(target[1])[target[2]].quantity += q
						if source[0].get(source[1])[source[2]].quantity - q > 0:
							source[0].get(source[1])[source[2]].quantity -= q
						else:
							source[0].get(source[1])[source[2]] = {"item" : null, "quantity" : 0, "use_time" : 0}
					else:
						move_item(source, target)
				elif target[0].get(target[1])[target[2]].item == "":
					if DB.item_db.get(source[0].get(source[1])[source[2]].item).STACKABLE:
						target[0].get(target[1])[target[2]] = source[0].get(source[1])[source[2]].duplicate()
						target[0].get(target[1])[target[2]].quantity = q
						if source[0].get(source[1])[source[2]].quantity - q > 0:
							source[0].get(source[1])[source[2]].quantity -= q
						else:
							source[0].get(source[1])[source[2]] = {"item" : null, "quantity" : 0, "use_time" : 0}
					else:
						move_item(source, target)
		else:
			if source[0].get(source[1])[source[2]].item == target[0].get(target[1])[target[2]].item:
				if DB.item_db.get(source[0].get(source[1])[source[2]].item).STACKABLE:
					target[0].get(target[1])[target[2]].quantity += q
					if source[0].get(source[1])[source[2]].quantity - q > 0:
						source[0].get(source[1])[source[2]].quantity -= q
					else:
						source[0].get(source[1])[source[2]] = {"item" : null, "quantity" : 0, "use_time" : 0}
				else:
					move_item(source, target)
			elif target[0].get(target[1])[target[2]].item == "":
				if DB.item_db.get(source[0].get(source[1])[source[2]].item).STACKABLE:
					target[0].get(target[1])[target[2]] = source[0].get(source[1])[source[2]].duplicate()
					target[0].get(target[1])[target[2]].quantity = q
					if source[0].get(source[1])[source[2]].quantity - q > 0:
						source[0].get(source[1])[source[2]].quantity -= q
					else:
						source[0].get(source[1])[source[2]] = {"item" : null, "quantity" : 0, "use_time" : 0}
				else:
					move_item(source, target)
	
	if source[1] == "inventory" || target[1] == "inventory":
		emit_signal("update_inventory")
	if source[1] == "equipment" || target[1] == "equipment":
		emit_signal("update_equipment")
		load_eq()
	emit_signal("update_quickbar")

func update_usage(used_item, usage_time):
	gcd_used = usage_time
	for e in equipment:
		if equipment.get(e).item == used_item:
			equipment.get(e).use_time = usage_time
	for i in inventory:
		if inventory.get(i).item == used_item:
			inventory.get(i).use_time = usage_time

func increase_stat(stat):
	if attributes.points > 0:
		attributes.player[stat] += 1
		attributes.points -= 1
		calculate_total_attributes()

func cast_spell(spell):
	if not enemy:
		get_target()
	if not enemy:
		return
	if global_transform.origin.distance_to(enemy.global_transform.origin) > float(DB.spell_db.get(spell).RANGE):
		return
	if DB.spell_db.get(spell).HEALTH_COST:
		if resources.health.current > float(DB.spell_db.get(spell).HEALTH_COST):
			modify_resource("health", -float(DB.spell_db.get(spell).HEALTH_COST))
		else:
			return
	if DB.spell_db.get(spell).MANA_COST:
		if resources.mana.current > float(DB.spell_db.get(spell).MANA_COST):
			modify_resource("mana", -float(DB.spell_db.get(spell).MANA_COST))
		else:
			return
	if DB.spell_db.get(spell).STAMINA_COST:
		if resources.stamina.current > float(DB.spell_db.get(spell).STAMINA_COST):
			modify_resource("stamina", -float(DB.spell_db.get(spell).STAMINA_COST))
		else:
			return
	if DB.spell_db.get(spell).TARGET_HEALTH:
		enemy.modify_resource("health", float(DB.spell_db.get(spell).TARGET_HEALTH))
	if DB.spell_db.get(spell).TARGET_MANA:
		enemy.modify_resource("mana", float(DB.spell_db.get(spell).TARGET_MANA))
	if DB.spell_db.get(spell).TARGET_STAMINA:
		enemy.modify_resource("stamina", float(DB.spell_db.get(spell).TARGET_STAMINA))
		
func get_target():
	var new_target = target_list.pop_front()
	if new_target:
		if enemy:
			emit_signal("target_ui", false)
			if $AttackArea.overlaps_body(enemy): 
				target_list.append(enemy)
		enemy = new_target
		look_at(enemy.global_transform.origin, Vector3.UP) # MAKE IT A LERPED ROTATION AROUND Y AXIS
		emit_signal("target_ui", true)
		
func add_lootable(creature_id, loot):
	lootable[creature_id] = loot

func get_eq_stats():
	for i in attributes.equipment:
		attributes.equipment[i] = 0
	for piece in equipment:
		if equipment.get(piece).item:
			if DB.item_db.get(equipment.get(piece).item).STR != null:
				attributes.equipment.strenght += int(DB.item_db.get(equipment.get(piece).item).STR)
			if DB.item_db.get(equipment.get(piece).item).DEX != null:
				attributes.equipment.dexterity += int(DB.item_db.get(equipment.get(piece).item).DEX)
			if DB.item_db.get(equipment.get(piece).item).INT != null:
				attributes.equipment.intelligence += int(DB.item_db.get(equipment.get(piece).item).INT)
			if DB.item_db.get(equipment.get(piece).item).CONST != null:
				attributes.equipment.constitution += int(DB.item_db.get(equipment.get(piece).item).CONST)
			if DB.item_db.get(equipment.get(piece).item).WIS != null:
				attributes.equipment.wisdom += int(DB.item_db.get(equipment.get(piece).item).WIS)
	calculate_total_attributes()

func calculate_total_attributes():
	for i in attributes.total:
		attributes.total[i] = 0
	for type in attributes:
		if type != "total" and type != "points":
			for one in attributes.get(type):
				attributes.total[one] += attributes.get(type).get(one)
	modify_resource("health", 0, attributes.total.constitution * 5)
	modify_resource("mana", 0, attributes.total.wisdom * 5)
	modify_resource("stamina", 0, attributes.total.dexterity * 5)
	emit_signal("update_stats", attributes.total, attributes.points)
