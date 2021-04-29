extends PanelContainer

var item_name : String = "test"
var item_description : String = "ldfhgksdhgksdfkgsdkhfg"
var item_stats : Dictionary = {
	"hp" : "2",
	"mp" : "25",
	"sp" : "23",
	"fk" : "5"
}

func _ready() -> void:
	hint_tooltip = "wierd fuckery"
	
	
func _make_custom_tooltip(for_text):
	var tooltip = preload("res://src/gui/tooltip/Tooltip.tscn").instance()
	tooltip.item_name = item_name
	tooltip.description = item_description
	tooltip.stats = item_stats
	return tooltip


func _on_Button_pressed() -> void:
	print("portret pressed")
