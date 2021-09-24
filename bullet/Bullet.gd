extends RigidBody

var bullet_force = 35

func _ready() -> void:
	$CPUParticles.emitting = true
	apply_central_impulse(-global_transform.basis.z * bullet_force)
	yield(get_tree().create_timer(10), "timeout")
	queue_free()

func _on_Bullet_body_entered(body: Node) -> void:
	$CollisionShape.set_deferred("disabled", true)
	hide()
