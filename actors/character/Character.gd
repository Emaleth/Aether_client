extends KinematicBody

var speed = 5
var model_height = 1.8

onready var bullet_origin : Position3D = $Position3D
onready var bullet : PackedScene = preload("res://bullet/Bullet.tscn")

var path = []


func set_camera_rig_transform(_path):
	$CameraRigTransform.remote_path = _path

func set_minimap_camera_transform(_path):
	$MinimapRemoteTransform.remote_path = _path
	
func _ready() -> void:
	$IK.configure(find_node("Skeleton"))
	
func _physics_process(delta: float) -> void:
	m(delta)
	define_player_state() 
	
func move_along(_path):
	path = []
	for i in _path:
		var fixed = i
		fixed.y += model_height / 2
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
		
	
func define_player_state():
	var player_state = {"T" : Server.client_clock, "pos" : global_transform.origin, "rot" : global_transform.basis, "hp" : 100, "max_hp" : 100, "mp" : 100, "max_mp" : 100}
	Server.send_player_state(player_state)

