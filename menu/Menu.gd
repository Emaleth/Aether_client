extends Control


onready var loading_label = $MarginContainer/LoadingProgress

func _ready() -> void:
	Server.msg_sys = self
	
func update_text(text):
	loading_label.text = text
