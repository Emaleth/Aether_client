extends KinematicBody


var data : Dictionary = {}
var velocity := 10.0
onready var camera_anchor : Position3D = $CameraAnchor
var path := []

func _ready() -> void:
	$Sprite3D.texture = $Sprite3D/Viewport.get_texture()
	process_data()
	
	
func _physics_process(delta: float) -> void:
	move(delta)
	
	
func configure(_data):
	data = _data


func process_data():
	print(str(data.keys()[0]))
	global_transform = data.values()[0]

	
func update(_data):
	for i in _data:
		data[i] = _data[i]
#	name_plate.update_health_bar(_data[0], data[1]["health"])

func set_target(_pos):
	path = _pos

	
func move(delta):
	var direction = Vector3()

	# We need to scale the movement speed by how much delta has passed,
	# otherwise the motion won't be smooth.
	var step_size = delta * velocity

	if path.size() > 0:
		# Direction is the difference between where we are now
		# and where we want to go.
		var destination = path[0]
		direction = destination - translation

		# If the next node is closer than we intend to 'step', then
		# take a smaller step. Otherwise we would go past it and
		# potentially go through a wall or over a cliff edge!
		if step_size > direction.length():
			step_size = direction.length()
			# We should also remove this node since we're about to reach it.
			path.remove(0)

		# Move the robot towards the path node, by how far we want to travel.
		# Note: For a KinematicBody, we would instead use move_and_slide
		# so collisions work properly.
		translation += direction.normalized() * step_size

		# Lastly let's make sure we're looking in the direction we're traveling.
		# Clamp y to 0 so the robot only looks left and right, not up/down.
		direction.y = 0
		if direction:
			# Direction is relative, so apply it to the robot's location to
			# get a point we can actually look at.
			var look_at_point = translation + direction.normalized()
			# Make the robot look at the point.
			look_at(look_at_point, Vector3.UP)
