extends SpringArm

var max_zoom : int = 7
var min_zoom : int = 2
var def_zoom : int = 5
var zoom_sensibility : float = 0.2
var pan_sensibility : float = 0.002
var pan_deadzone : float = 0.1
var pan_return_speed : float = 10
var cur_rot_x : float
var def_rot_x : float = deg2rad(-15)

func _ready() -> void:
	cur_rot_x = def_rot_x
	spring_length = def_zoom

func _unhandled_input(event: InputEvent) -> void:
### ZOOM ###
	if Input.is_action_just_pressed("zoom_in"):
		spring_length -= zoom_sensibility
	elif Input.is_action_just_pressed("zoom_out"):
		spring_length += zoom_sensibility
	spring_length = clamp(spring_length, min_zoom, max_zoom)
		
### PAN ###
	if Input.is_action_pressed("pan"):
		if event is InputEventMouseMotion:
			if abs(event.relative.y) > pan_deadzone:
				rotation.x -= event.relative.y * pan_sensibility
				rotation.x = clamp(rotation.x, deg2rad(-80), deg2rad(80))
			if abs(event.relative.x) > pan_deadzone:
				rotation.y -= event.relative.x * pan_sensibility
### MOVE ###
	if Input.is_action_pressed("secondary_action"):
		if event is InputEventMouseMotion:
			if abs(event.relative.y) > pan_deadzone:
				rotation.x -= event.relative.y * pan_sensibility
				rotation.x = clamp(rotation.x, deg2rad(-80), deg2rad(80))
				cur_rot_x = rotation.x

			
func _process(delta: float) -> void:
	if Input.is_action_pressed("pan"):
		return
	else:
		rotation.x = lerp_angle(rotation.x, cur_rot_x, pan_return_speed * delta)
		rotation.y = lerp_angle(rotation.y, 0, pan_return_speed * delta)
