extends "res://source/ui/subcomponents/window/Window.gd"

var buttons = [
	"skill_1",
	"skill_2",
	"skill_3",
	"skill_4",
	"skill_5",
	"skill_6",
	"skill_7",
	"skill_8",
	"skill_9",
	"skill_10"
]

##func configure(_camera):
##	for i in $GridContainer.get_children().size():
##		$GridContainer.get_child(i).conf(buttons[i], _camera)
#
#
#
##func _unhandled_input(event: InputEvent) -> void:
##	if shortcut != null and item != null:
##		if Input.is_action_just_pressed(shortcut):
##			var target = camera.get_action_target()
##			if target != null:
##				Server.send_action_request(item, target.name)
