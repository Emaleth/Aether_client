extends Control

func _process(delta: float) -> void:
	$CanvasLayer/TextureRect.rect_position = rect_position - Vector2(20, 20)
	

