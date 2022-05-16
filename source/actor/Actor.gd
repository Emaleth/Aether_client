extends KinematicBody


var data : Dictionary = {}
var velocity := 10.0
var path := []

onready var camera_remote_transform : RemoteTransform = $CameraRemoteTransform


func _ready() -> void:
	$Sprite3D.texture = $Sprite3D/Viewport.get_texture()
	process_data()
	
	
func _physics_process(delta: float) -> void:
	move(delta)
	
	
func configure(_data):
	data = _data


func process_data():
	name = str(data.keys()[0])
	global_transform = data.values()[0]

	
func update(_data):
	for i in _data:
		data[i] = _data[i]
		

func update_path(_path):
	path = _path

	
func bind_camera(_node_path):
	camera_remote_transform.remote_path = _node_path
	
	
func move(delta):
	var direction = Vector3()
	var step_size = delta * velocity
	if path.size() > 0:
		var destination = path[0]
		direction = destination - translation
		if step_size > direction.length():
			step_size = direction.length()
			path.remove(0)
		translation += direction.normalized() * step_size
		direction.y = 0
		if direction:
			var look_at_point = translation + direction.normalized()
			look_at(look_at_point, Vector3.UP)
