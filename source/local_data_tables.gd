extends Node

var enemy_table := {}
var skill_table := {}
var item_table := {}

var animation_data := {}


func _ready() -> void:
	animation_data = load_json("res://data/animation_data.json")
	
func load_json(file) -> Dictionary:
	var db_file = File.new()
	db_file.open(file, File.READ)
	var db_json = JSON.parse(db_file.get_as_text())
	db_file.close()
	
	return db_json.result

