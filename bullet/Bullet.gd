extends Area

var velocity = 10

	
func _physics_process(delta: float) -> void:
	global_transform.origin += -global_transform.basis.z * velocity * delta

func _on_Bullet_body_entered(body: Node) -> void:
	$CollisionShape.set_deferred("disabled", true)
	hide()

func _on_Timer_timeout() -> void:
	queue_free()
