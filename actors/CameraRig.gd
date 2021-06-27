extends SpringArm

var sensibility : float = 0.002
var deadzone : float = 0.1
var default_rotation_x : float = deg2rad(-15)

onready var timer = $Timer
onready var tween = $Tween
onready var raycast = $Camera/RayCast


func _ready() -> void:
	rotation.x = default_rotation_x
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			tween.stop_all()
			if abs(event.relative.y) > deadzone:
				rotation.x -= event.relative.y * sensibility
				rotation.x = clamp(rotation.x, deg2rad(-80), deg2rad(80))
				timer.start(1)

func get_point():
	raycast.force_raycast_update()
#	print(raycast.get_collider().name)
	return raycast.get_collision_point()

func _on_Timer_timeout() -> void:
	tween.remove_all()
	tween.interpolate_property(self, "rotation:x", rotation.x, default_rotation_x, 1.0/abs(rotation.x - default_rotation_x), Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()
