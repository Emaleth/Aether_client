extends "res://source/ui/subcomponents/window/Window.gd"

onready var clock_label = $VBoxContainer/ContentPanel/Label


func _ready() -> void:
	window_title_label.text = "Clock"
	
func _physics_process(delta: float) -> void:
	clock_label.text = format_time()
	
func format_time():
	var date_dict = OS.get_datetime_from_unix_time(Server.client_clock / 1000)
	var hour : String
	var minute : String
	var second : String
	if date_dict["hour"] < 10:
		hour = "0" + str(date_dict["hour"])
	else:
		hour = str(date_dict["hour"])
		
	if date_dict["minute"] < 10:
		minute = "0" + str(date_dict["minute"])
	else:
		minute = str(date_dict["minute"])
		
	if date_dict["second"] < 10:
		second = "0" + str(date_dict["second"])
	else:
		second = str(date_dict["second"])
		
	var formatted_time := "%s:%s:%s" % [hour, minute, second]
	return formatted_time
