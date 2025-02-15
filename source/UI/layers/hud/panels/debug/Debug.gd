extends PanelContainer


onready var latency_label = $VBoxContainer/Latency
onready var fps_label = $VBoxContainer/FPS
onready var clock_label = $VBoxContainer/Clock


func _physics_process(_delta: float) -> void:
	latency_label.text = "Latency: %s" % Server.latency
	fps_label.text = "Fps: %s" % Engine.get_frames_per_second()
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
