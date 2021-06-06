extends Spatial

var types  = {
	"friendly" : Color.green,
	"enemy" : Color.red,
	"npc" : Color.blue
}

onready var tween : Tween = $Tween
onready var target_indicator : Spatial = $TargetIndicator
onready var minimap_indicator : Spatial = $MinimapIndicator
onready var map_indicator : Spatial = $MapIndicator

var type = "enemy"

func _ready() -> void:
	target_indicator.modulate = types.get(type)
	minimap_indicator.modulate = types.get(type)
	map_indicator.modulate = types.get(type)
	
func bounce():
	target_indicator.transform.origin.y = 3.3
	target_indicator.show()
	tween.remove_all()
	tween.interpolate_property(target_indicator, "transform:origin:y", 3.3, 3, 0.7, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.interpolate_property(target_indicator, "transform:origin:y", 3, 3.3, 1, Tween.TRANS_SINE, Tween.EASE_OUT, 0.7)
	tween.start()
		
func halt():
	target_indicator.hide()
	tween.stop_all()

	
