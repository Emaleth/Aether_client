extends Node


onready var landscape_scene = preload("res://source/environment/World.tscn")


func _ready() -> void:
	make_landscape()
	

func make_landscape():
	add_child(landscape_scene.instance())
