extends Spatial

var types  = {
	"friendly" : Color.green,
	"enemy" : Color.red,
	"npc" : Color.blue,
	"neutral" : Color.whitesmoke,
}

onready var tween : Tween = $Tween
onready var target_indicator : MeshInstance = $TargetIndicator
var type

func _ready() -> void:
	type = "enemy"
	target_indicator.transform.origin.y = 3
	bounce()
	
func bounce():
	tween.remove_all()
	tween.interpolate_property(target_indicator, "transform:origin:y", 3, 3.3, 1, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.interpolate_property(target_indicator, "transform:origin:y", 3.3, 3, 1, Tween.TRANS_QUAD, Tween.EASE_IN, 1)
	tween.start()
		
