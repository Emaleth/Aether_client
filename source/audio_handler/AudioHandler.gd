extends Node


onready var button_sfx = preload("res://assets/sound/ui/click_003.ogg")
onready var combat_layer_sfx = preload("res://assets/sound/ui/click_001.ogg")
onready var managment_layer_sfx = preload("res://assets/sound/ui/click_001.ogg")
onready var shop_layer_sfx = preload("res://assets/sound/ui/click_001.ogg")
onready var audio_player = $AudioStreamPlayer


func play_sfx(_sfx):
	match _sfx:
		"button":
			audio_player.stream = button_sfx
		"combat_layer":
			audio_player.stream = combat_layer_sfx
		"managment_layer":
			audio_player.stream = managment_layer_sfx
		"shop_layer":
			audio_player.stream = shop_layer_sfx
			
	audio_player.play()
