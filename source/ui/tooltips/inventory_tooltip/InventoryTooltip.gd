extends PanelContainer

onready var name_label = $VBoxContainer/NameLabel
onready var description_label = $VBoxContainer/DescriptionLabel
onready var msrp_label = $VBoxContainer/MsrpLabel
var item := {}

	
func _ready() -> void:
	var data = get_item_data(item["item"])
	
	name_label.text = str(data[0]["name"])
	description_label.text = str(data[0]["description"])
	msrp_label.text = str(data[0]["msrp"])


static func get_item_data(_item : String) -> Array:
	var index_data := {}
	var type_data := {}
	index_data = LocalDataTables.item_index[_item]
#	match index_data["type"]:
#		"armor":
#			type_data = LocalDataTables.armor_table[_item]
#		"material":
#			type_data = LocalDataTables.material_table[_item]
#		"craft_recipe":
#			type_data = LocalDataTables.craft_recipe_table[_item]
	return [index_data, type_data]
	
	
func _process(_delta: float) -> void:
	check_in_window()
	
	
func conf(_item):
	item = _item


func check_in_window():
	rect_global_position.x = clamp(rect_global_position.x, 0, OS.window_size.x - rect_size.x)
	rect_global_position.y = clamp(rect_global_position.y, 0, OS.window_size.y - rect_size.y)
	
