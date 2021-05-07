extends Spatial

var types  = {
	"friendly" : Color.green,
	"enemy" : Color.red,
	"npc" : Color.blue,
	"neutral" : Color.whitesmoke,
}

onready var tween : Tween = $Tween
onready var target_indicator : Spatial = $TargetIndicator
onready var minimap_indicator : MeshInstance = $MinimapIndicator
var type

func _ready() -> void:
	type = "enemy"
	target_indicator.transform.origin.y = 3.3
	
func bounce():
	target_indicator.show()
	tween.remove_all()
	tween.interpolate_property(target_indicator, "transform:origin:y", 3.3, 3, 0.7, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.interpolate_property(target_indicator, "transform:origin:y", 3, 3.3, 1, Tween.TRANS_SINE, Tween.EASE_OUT, 0.7)
	tween.start()
		
func halt():
	target_indicator.hide()
	tween.stop_all()
	target_indicator.transform.origin.y = 3.3
	
