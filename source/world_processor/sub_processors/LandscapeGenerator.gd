extends Node


onready var landscape_scene = preload("res://source/world/World.tscn")


func create_landscape():
	add_child(landscape_scene.instance())


