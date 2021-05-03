extends Button

var item_uid : String
var quantity : int
var inventory = null

onready var texture = $TextureRect
onready var q_label = $Label

func _ready() -> void:
	q_label.text = ""
	
func conf(inv = null, item = "", q = 1):
	if inv:
		inventory = inv
	item_uid = item
	quantity = q
	if item_uid:
		disabled = false
		texture.texture = load("res://previews/%s.png" % item)
		hint_tooltip = "wierd fuckery"
	else:
		disabled = true
		texture.texture = null
		hint_tooltip = ""
	
	if q > 1:
		q_label.text = str(q)
	else:
		q_label.text = ""
	
	
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

	swap()
	
func swap():
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
	pass # Consume
