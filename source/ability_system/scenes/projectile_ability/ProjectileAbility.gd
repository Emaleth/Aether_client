extends Area

onready var server = get_node("/root/Server")

var data : Array

onready var collision_shape := $CollisionShape


func configure(transform_array : Array, _data : Array):
	global_transform = transform_array[1]
	data = _data.duplicate(true)


func _physics_process(delta: float) -> void:
	travel(delta)


func travel(_delta : float):
	global_transform.origin += global_transform.basis.xform(Vector3.FORWARD * data[1]["speed"] * _delta) 
	

func impact(_body : Node):
	queue_free()
	
#
func _on_ProjectileAbility_body_entered(body: Node) -> void:
	impact(body)
