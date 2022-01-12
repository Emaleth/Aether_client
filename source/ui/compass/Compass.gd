extends PanelContainer

onready var direction_strip = $Control/HBoxContainer


func _process(delta: float) -> void:
	configure(GlobalVariables.player_actor.rotation_degrees.y)
	
	
func configure(_degrees : float):
	var center = rect_size.x / 2.0
	var step = direction_strip.rect_size.x / 720.0
	direction_strip.rect_position.x = (-direction_strip.rect_size.x / 2.0 + center + (step * _degrees)) 



