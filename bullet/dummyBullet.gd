extends Area

#func _ready() -> void:
#	$CPUParticles.emitting = true

func update(new_position, new_rotation):
	transform.origin = new_position
	transform.basis = new_rotation
		
