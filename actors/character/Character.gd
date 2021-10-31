extends KinematicBody

var speed = 5
var model_height = 1.8
var path = []

onready var camera_rig_remote_transform = $CameraRigRemoteTransform
onready var minimap_remote_transform = $MinimapRemoteTransform


func set_camera_rig_transform(_path):
	camera_rig_remote_transform.remote_path = _path

func set_minimap_camera_transform(_path):
	minimap_remote_transform.remote_path = _path
	
func _ready() -> void:
	$IK.configure(find_node("Skeleton"))
	
func _physics_process(delta: float) -> void:
	m(delta)
	
func move_along(_path):
	path = []
	for i in _path:
		var fixed = i
		fixed.y += model_height / 2 - 0.1
		path.append(fixed)
	
func m(delta):
	var direction = Vector3()
	var step_size = delta * speed
	if path.size() > 0:
		$IK.animate(Vector3.FORWARD * speed)
		var destination = path[0]
		direction = destination - global_transform.origin
		if step_size > direction.length():
			step_size = direction.length()
			path.remove(0)
		global_transform.origin += direction.normalized() * step_size
		direction.y = 0
		if direction:
			var look_at_point = global_transform.origin + direction.normalized()
			look_at(look_at_point, Vector3.UP)
	else:
		$IK.animate(Vector3.ZERO)
		
