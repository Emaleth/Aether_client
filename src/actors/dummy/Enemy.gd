extends "res://src/actors/Actor.gd"


func _ready() -> void:
	statistics.name = "Dummy"
	statistics.race = "null"
	statistics.guild = "trash"
	statistics.level = "5"
	statistics.title = "virus"
	
	model = preload("res://models/human.fbx")
	$Debug.queue_free()
	conf()
	load_eq()
	for i in model.get_children():
		if i is MeshInstance:
			pass # set albedo to red
