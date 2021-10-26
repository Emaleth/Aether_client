extends Area

var target = null
var speed = 10
var type
	
	
func _physics_process(delta: float) -> void:
	if is_instance_valid(target):
		global_transform.origin = global_transform.origin.linear_interpolate(target.global_transform.origin, speed * delta)
	else:
		queue_free()
	
func conf(_target):
	target = _target
	
func _on_Bullet_body_entered(body: Node) -> void:
	$CollisionShape.set_deferred("disabled", true)
	queue_free()
