extends PanelContainer

onready var label = $Label
var item := {}

func conf(_item):
	item = _item
	
func _ready() -> void:
	var tooltip_text := ""
	if item:
		tooltip_text += str(item["archetype"])
		for i in LocalDataTables.item_table[item["archetype"]]:
			tooltip_text += "\n%s : %s" % [i, LocalDataTables.item_table[item["archetype"]][i]]
	label.text = tooltip_text
