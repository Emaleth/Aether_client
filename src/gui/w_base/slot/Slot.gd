extends Panel

var item_uid : String
var quantity : int

onready var texture = $TextureRect
onready var q_label = $Label


func conf(item, q = 1):
	item_uid = item
	quantity = q
	if item_uid:
		texture.texture = preload("res://icon.png")
		hint_tooltip = "wierd fuckery"
	
		if q > 1:
			q_label.text = str(q)
		else:
			q_label.text = ""
	else:
		texture.texture = null
		hint_tooltip = ""
		q_label.hide()
	
	
func _make_custom_tooltip(for_text):
	if item_uid:
		var tooltip = preload("res://src/gui/tooltip/Tooltip.tscn").instance()
		tooltip.item_name = DataLoader.item_db.get(item_uid).NAME
	#	tooltip.description = item_description
	#	tooltip.stats = item_stats
		return tooltip
