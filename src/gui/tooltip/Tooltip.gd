extends PanelContainer


var item_name : String
var stats : Dictionary = {
	"hp" : "2",
	"mp" : "25",
	"sp" : "23",
	"fk" : "5"
}

onready var stat_row = preload("res://src/gui/tooltip/StatRow.tscn").instance()
onready var stat_container : Container = $MarginContainer/VBoxContainer/StatContainer

func _ready() -> void:
	get_stats()
	
func get_stats() -> void:
	for i in stats:
		var sr = stat_row.duplicate()
		stat_container.add_child(sr)
		sr.conf("sdf", "sdf", "sdf")
		
