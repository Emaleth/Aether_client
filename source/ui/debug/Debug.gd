extends PanelContainer

onready var latency_label = $VBoxContainer/Latency
onready var fps_label = $VBoxContainer/FPS


func conf(_latency):
	latency_label.text = "Latency: %s" % _latency
	
func _physics_process(_delta: float) -> void:
	fps_label.text = "Fps: %s" % Engine.get_frames_per_second()

