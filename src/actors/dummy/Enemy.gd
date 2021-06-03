extends "res://src/actors/Actor.gd"


func _ready() -> void:
	statistics.name = "Dummy"
	statistics.guild = ""
	statistics.level = "5"
	statistics.title = ""
	
	model = preload("res://models/human_male.fbx")
#	$Debug.queue_free()
	conf()
#	load_eq()
