extends CenterContainer

var crosshairs = {
	"look" : preload("res://assets/texture/crosshair/crosshair140.png"),
	"combat" : preload("res://assets/texture/crosshair/ch_combat.png")
}

onready var crosshair : TextureRect = $TextureRect


func _process(delta: float) -> void:
	if Input.is_action_pressed("secondary_action") || Input.is_action_pressed("pan"):
		show()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if Input.is_action_pressed("secondary_action"):
		crosshair.texture = crosshairs.combat
	if Input.is_action_pressed("pan"):
		crosshair.texture = crosshairs.look
		
