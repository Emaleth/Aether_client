extends PanelContainer

onready var name_label = $VBoxContainer/NameLabel
onready var description_label = $VBoxContainer/DescriptionLabel
onready var msrp_label = $VBoxContainer/MsrpLabel
var item : String

	
func _ready() -> void:
	var data = GlobalVariables.get_item_data(item)
	
	name_label.text = str(data[0]["name"])
	description_label.text = str(data[0]["description"])
	msrp_label.text = str(data[0]["msrp"])
	
	
func _process(_delta: float) -> void:
	check_in_window()
	
	
func conf(_item):
	item = _item


func check_in_window():
	rect_global_position.x = clamp(rect_global_position.x, 0, OS.window_size.x - rect_size.x)
	rect_global_position.y = clamp(rect_global_position.y, 0, OS.window_size.y - rect_size.y)
	
