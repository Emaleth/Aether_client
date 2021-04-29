extends "res://src/actors/Actor.gd"


func _ready() -> void:
	statistics.name = "Dummy"
	statistics.race = "null"
	statistics.guild = "trash"
	statistics.level = "5"
	statistics.title = "virus"
	
#	Input.set_use_accumulated_input(false)
	model = preload("res://assets/model/actors/ybot.fbx")
	$Debug.queue_free()
	conf()
	for i in model.get_children():
		if i is MeshInstance:
			pass # set albedo to red
