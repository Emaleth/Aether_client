extends WindowDialog


func _ready() -> void:
	window_title = tr("1011")
	show()

func _on_MarginContainer_sort_children() -> void:
	rect_min_size = $MarginContainer.rect_min_size
	rect_size = $MarginContainer.rect_size
