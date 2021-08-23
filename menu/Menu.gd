extends Control

onready var game = preload("res://world/World.tscn")

func _ready():
	Server.connect("logged_in",self, "enter_world")
	
func enter_world():
	get_tree().change_scene_to(game)
	
