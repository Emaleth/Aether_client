extends KinematicBody

onready var health_bar = $Viewport/AnimatedProgressBar


func update(new_position, new_rotation, _hp, _max_hp):
	transform.origin = new_position
	transform.basis = new_rotation
	health_bar.update_ui(_hp, _max_hp)

func target(_bool):
	if _bool:
		$DEBUG_Body.get("material/0").albedo_color = Color.red
	else:
		$DEBUG_Body.get("material/0").albedo_color = Color.whitesmoke
