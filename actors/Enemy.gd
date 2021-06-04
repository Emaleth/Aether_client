extends "res://actors/Actor.gd"


func _ready() -> void:
	statistics.name = "Dummy"
	statistics.guild = ""
	statistics.level = "5"
	statistics.title = ""

	conf()

