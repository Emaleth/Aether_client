extends PanelContainer


var item_name : String 
var description : String 
var stats : Dictionary 

onready var stat_row = preload("res://src/gui/tooltip/StatRow.tscn").instance()
onready var stat_container : Container = $MarginContainer/VBoxContainer/StatContainer
onready var name_label = $MarginContainer/VBoxContainer/Name
onready var name_separator = $MarginContainer/VBoxContainer/HSeparator
onready var description_label = $MarginContainer/VBoxContainer/Description
onready var description_separator = $MarginContainer/VBoxContainer/HSeparator2
	
func _ready() -> void:
	get_stats()
	
	
func get_stats() -> void:
	if item_name:
		name_label.text = item_name
	else:
		name_label.hide()
		name_separator.hide()
	
	if description:
		description_label.text = description
	else:
		description_label.hide()
	
		description_separator.hide()
	if stats:
		for i in stats:
			var sr = stat_row.duplicate()
			stat_container.add_child(sr)
			sr.conf("sdf", "sdf", "sdf")

