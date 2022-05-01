extends Area

onready var server = get_node("/root/Server")

var data : Array

onready var collision_shape := $CollisionShape


func configure(_transform : Transform, _data : Array):
	global_transform = _transform
	data = _data.duplicate(true)
