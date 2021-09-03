extends RigidBody

var bullet_force = 50

func _ready() -> void:
	apply_central_impulse(-global_transform.basis.z * bullet_force)
	yield(get_tree().create_timer(5), "timeout")
	queue_free()

