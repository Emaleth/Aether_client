extends PanelContainer

onready var direction_strip = $Control/HBoxContainer


func _process(delta: float) -> void:
	configure(GlobalVariables.player_actor.rotation_degrees.y)
	
	
func configure(_degrees : float):
	var normalized_rot = _degrees / 180.0
	var moved_amount = normalized_rot * direction_strip.rect_size.x 
	direction_strip.rect_position.x = moved_amount / 2.0
	direction_strip.rect_position.x = wrapf(direction_strip.rect_position.x / 2, -direction_strip.rect_size.x / 4, direction_strip.rect_size.x / 4)

