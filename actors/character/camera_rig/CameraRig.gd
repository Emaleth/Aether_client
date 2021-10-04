extends SpringArm

var sensibility : float = 0.002
var deadzone : float = 0.1
var default_rotation_x : float = deg2rad(-15)

onready var ray : RayCast = $Camera/RayCast
onready var ray_end = $Camera/Position3D

signal show_aim_hint
signal new_target


func configure():
	rotation.x = default_rotation_x
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			if abs(event.relative.y) > deadzone:
				rotation.x -= event.relative.y * sensibility
				rotation.x = clamp(rotation.x, deg2rad(-80), deg2rad(80))

func _physics_process(delta: float) -> void:
	if ray.is_colliding():
		emit_signal("show_aim_hint", ray.get_collider().name)
	else:
		emit_signal("show_aim_hint", "")
		
func aim():
	if ray.is_colliding():
		emit_signal("new_target", ray.get_collision_point())
	else:
		emit_signal("new_target", ray_end.global_transform.origin)
		
