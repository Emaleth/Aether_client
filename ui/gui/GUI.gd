extends CanvasLayer

onready var clock_label = $PanelContainer/Clock

func _physics_process(_delta: float) -> void:
	var date_dict = OS.get_datetime_from_unix_time(Server.client_clock / 1000)
	clock_label.text = "Server Time: %s:%s:%s" % [date_dict["hour"], date_dict["minute"], date_dict["second"]]
