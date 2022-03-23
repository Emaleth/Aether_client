extends Spatial


var lifetime = 0.05

onready var tween = $Tween
onready var mesh1 = $Plane
onready var mesh2 = $Plane001

	
func conf(start_pos = Vector3(), end_pos = Vector3()):
#	global_transform.origin = start_pos
	
	var lenght = start_pos.distance_to(end_pos)
	mesh1.scale.z = lenght
	mesh2.scale.z = lenght
	
	tween.remove_all()
	tween.interpolate_property(mesh1, "scale:z", lenght, 0, lifetime, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(mesh2, "scale:z", lenght, 0, lifetime, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	
	show()
	yield(tween, "tween_all_completed")
	hide()
	
