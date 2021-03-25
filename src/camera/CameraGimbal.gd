extends SpringArm

var max_zoom : int = 10
var min_zoom : int = 3
var def_zoom : int = 7
var zoom_sensibility : float = 0.1
var pan_sensibility : float = 0.002
var pan_deadzone : float = 0.1
var pan_return_speed : float = 10

onready var camera : Camera = $Camera

func _ready() -> void:
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
				camera.rotation.x -= event.relative.y * pan_sensibility
				camera.rotation.x = clamp(
					camera.rotation.x, 
					max(deg2rad(-80), deg2rad(-80 + rotation.x)), 
					min(deg2rad(80), deg2rad(80 - rotation.x))
					)
			if abs(event.relative.x) > pan_deadzone:
				camera.rotation.y -= event.relative.x * pan_sensibility
### MOVE ###
	if Input.is_action_pressed("secondary_action"):
		if event is InputEventMouseMotion:
			if abs(event.relative.y) > pan_deadzone:
				rotation.x -= event.relative.y * pan_sensibility
				rotation.x = clamp(
					rotation.x, 
					max(deg2rad(-80), deg2rad(-80 + camera.rotation.x)), 
					min(deg2rad(80), deg2rad(80 - camera.rotation.x))
					)
			
func _process(delta: float) -> void:
	if Input.is_action_pressed("pan"):
		return
	else:
		camera.rotation.x = lerp_angle(camera.rotation.x, 0, pan_return_speed * delta)
		camera.rotation.y = lerp_angle(camera.rotation.y, 0, pan_return_speed * delta)
