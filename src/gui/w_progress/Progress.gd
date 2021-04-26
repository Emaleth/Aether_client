extends PanelContainer

onready var health_bar = $MarginContainer/HBoxContainer/VBoxContainer/Health
onready var mana_bar = $MarginContainer/HBoxContainer/VBoxContainer/Mana
onready var stamina_bar = $MarginContainer/HBoxContainer/VBoxContainer/Stamina
onready var name_label = $MarginContainer/HBoxContainer/VBoxContainer/TargetStuff/Name
onready var lvl_label = $MarginContainer/HBoxContainer/VBoxContainer/TargetStuff/Lvl
onready var class_texture = $MarginContainer/HBoxContainer/VBoxContainer/TargetStuff/Class
onready var target_stuff = $MarginContainer/HBoxContainer/VBoxContainer/TargetStuff
