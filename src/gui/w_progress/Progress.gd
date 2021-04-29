extends Control

onready var health_bar = $VSplitContainer/Progress/MarginContainer/HBoxContainer/VBoxContainer/Health
onready var mana_bar = $VSplitContainer/Progress/MarginContainer/HBoxContainer/VBoxContainer/Mana
onready var stamina_bar = $VSplitContainer/Progress/MarginContainer/HBoxContainer/VBoxContainer/Stamina
onready var name_label = $VSplitContainer/Progress/MarginContainer/HBoxContainer/VBoxContainer/TargetStuff/Name
onready var lvl_label = $VSplitContainer/Progress/MarginContainer/HBoxContainer/VBoxContainer/TargetStuff/Lvl
onready var class_texture = $VSplitContainer/Progress/MarginContainer/HBoxContainer/VBoxContainer/TargetStuff/Class
onready var target_stuff = $VSplitContainer/Progress/MarginContainer/HBoxContainer/VBoxContainer/TargetStuff
