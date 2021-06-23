extends Control


func _process(_delta: float) -> void:
	$CanvasLayer/TextureRect.rect_position = rect_position - Vector2(20, 20)
	
func conf(icon):
	$CanvasLayer/TextureRect.texture = icon
