extends PanelContainer

onready var label = $Label

func conf(text : String = ""):
	if not is_inside_tree():
		yield(self, "ready")
	if text == "":
		label.hide()
	else:
		label.text = text

func _on_TextTooltip_sort_children() -> void:
	rect_min_size = label.rect_size
	rect_position.x = min(rect_position.x, OS.get_screen_size().x - rect_size.x)
	rect_position.y = min(rect_position.y, OS.get_screen_size().y - rect_size.y)
