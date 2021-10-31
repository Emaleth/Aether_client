extends GridContainer
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

	
func configure(_camera):
	for i in get_children().size():
		get_child(i).conf(buttons[i], _camera)
