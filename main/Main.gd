extends Node

onready var game = preload("res://world/World.tscn")
onready var menu = preload("res://menu/Menu.tscn")


func get_game():
	get_tree().change_scene_to(game)
	
