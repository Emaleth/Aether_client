extends KinematicBody

enum STANCE {NORMAL, COMBAT, DEAD}
enum STATE {IDLE, WALK, JUMP}

var res : Dictionary = {
	"health" : 0,
	"mana" : 0,
	"stamina" : 0
}

var eq : Dictionary = {
	"mainhand" : null,
	"offhand" : null,
	"boots" : null,
	"gloves" : null,
	"torso" : null,
	"helmet" : null,
	"cape" : null
}
	
var inv : Array = []
