extends "res://src/actors/Actor.gd"

var speed = 7
var jump = 9
var velocity = Vector3()
var gravity = 20 
var acceleration = 15
var gravity_vec = Vector3()

func _physics_process(delta: float) -> void:
	move_and_slide(calculate_velocity(delta) + calculate_gravity(delta), Vector3.UP)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("secondary_action"):
		if event is InputEventMouseMotion:
#			if abs(event.relative.y) > pan_deadzone:
			rotation.y -= event.relative.x * 0.01
	
func get_direction() -> Vector2:
	var direction = Vector3()
	direction += (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")) * transform.basis.z
	direction += (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * transform.basis.x
	direction = direction.normalized()
	return direction
	
func calculate_gravity(delta):
	if is_on_floor():
		gravity_vec = Vector3.DOWN * gravity * delta
	else:
		gravity_vec += Vector3.DOWN * gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		gravity_vec = Vector3.UP * jump

	return gravity_vec
	
func calculate_velocity(delta):
	velocity = velocity.linear_interpolate(get_direction() * speed, acceleration * delta)
	return velocity
