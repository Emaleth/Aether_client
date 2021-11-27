extends PanelContainer

onready var label = $Label
var item := {}

	
func _ready() -> void:
	var tooltip_text := ""
	if item:
		tooltip_text += str(item["archetype"])
		for i in LocalDataTables.item_table[item["archetype"]]:
			tooltip_text += "\n%s : %s" % [i, LocalDataTables.item_table[item["archetype"]][i]]
	label.text = tooltip_text


func conf(_item):
	item = _item


func check_in_window():
	rect_global_position.x = clamp(rect_global_position.x, 0, OS.window_size.x - rect_size.x)
	rect_global_position.y = clamp(rect_global_position.y, 0, OS.window_size.y - rect_size.y)
	
