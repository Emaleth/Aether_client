extends Node

onready var game = preload("res://world/World.tscn")
onready var menu = preload("res://menu/Menu.tscn")

func _ready() -> void:
	get_tree().change_scene_to(menu)

func get_game():
	get_tree().change_scene_to(game)
	
