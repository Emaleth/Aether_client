extends Button

var item_uid : String
var quantity : int
var inventory = null
var place_in_actor = null
var eq_slot = false

onready var texture = $TextureRect
onready var q_label = $Label

func _ready() -> void:
	q_label.text = ""
	disabled = true
	
func conf(inv = null, item = "", q = 1, pia : int = -1, eq : bool = false):
	if eq:
		eq_slot = true
	if pia != -1:
#		print(pia)
		place_in_actor = pia
	if inv:
		inventory = inv
	if item && q > 0:
		quantity = q
		item_uid = item
		if DataLoader.item_db.get(item).CONSUMABLE == true:
			disabled = false
		else:
			disabled = true
		texture.texture = load("res://previews/%s.png" % item)
		hint_tooltip = "wierd fuckery"
	else:
		quantity = 1
		item_uid = ""
		disabled = true
		texture.texture = null
		hint_tooltip = ""
	
	if q > 1:
		q_label.text = str(q)
	else:
		q_label.text = ""
	
	if pia == -1:
		update_og_inv()
		
func _make_custom_tooltip(for_text):
	if item_uid:
		var tooltip = preload("res://src/gui/tooltip/Tooltip.tscn").instance()
		tooltip.item_name = DataLoader.item_db.get(item_uid).NAME
	#	tooltip.description = item_description
	#	tooltip.stats = item_stats
		return tooltip
		
func get_drag_data(position: Vector2):
	inventory.source_slot["slot"] = self
	inventory.source_slot["item"] = item_uid
	inventory.source_slot["quantity"] = quantity
	
	make_preview()
	
	return inventory.source_slot

func can_drop_data(position: Vector2, data) -> bool:
	return true
	
func drop_data(position: Vector2, data) -> void:
	inventory.target_slot["slot"] = self
	inventory.target_slot["item"] = item_uid
	inventory.target_slot["quantity"] = quantity
	if not eq_slot:
		swap()
	elif eq_slot:
		pass
		
func swap():
	if inventory.target_slot["slot"] != inventory.source_slot["slot"]:
		if inventory.target_slot["item"] == inventory.source_slot["item"]:
			if DataLoader.item_db.get(inventory.target_slot["item"]).STACKS == true: # change to bool
				print(DataLoader.item_db.get(inventory.target_slot["item"]).STACKS)
				inventory.source_slot["slot"].conf(null, "", 0)
				inventory.target_slot["slot"].conf(null, inventory.source_slot["item"], (inventory.source_slot["quantity"] + inventory.target_slot["quantity"]))
			else:
				inventory.source_slot["slot"].conf(null, inventory.target_slot["item"], inventory.target_slot["quantity"])
				inventory.target_slot["slot"].conf(null, inventory.source_slot["item"], inventory.source_slot["quantity"])
		else:
			inventory.source_slot["slot"].conf(null, inventory.target_slot["item"], inventory.target_slot["quantity"])
			inventory.target_slot["slot"].conf(null, inventory.source_slot["item"], inventory.source_slot["quantity"])


func make_preview():
	var pw = TextureRect.new()
	pw.expand = true
	pw.texture = texture.texture
	pw.rect_min_size = Vector2(40, 40)
	pw.self_modulate = Color.cadetblue
	set_drag_preview(pw)


func _on_Slot_pressed() -> void: 
	if DataLoader.item_db.get(item_uid).CONSUMABLE == true:
		conf(null, item_uid, (quantity - 1))
	# trigget some function
	
	
#func _unhandled_input(event: InputEvent) -> void:
#	if Input.is_action_just_pressed("jump"):
#		test()
#
#func test():
#	print(place_in_actor)
#	print(inventory.actor_inv.get(place_in_actor))
	
func update_og_inv():
	if item_uid != inventory.actor_inv.get(place_in_actor)["item"]:
		inventory.actor_inv.get(place_in_actor)["item"] = item_uid
	if quantity != inventory.actor_inv.get(place_in_actor)["quantity"]:
		inventory.actor_inv.get(place_in_actor)["quantity"] = quantity
		
