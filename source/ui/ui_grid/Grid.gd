extends PanelContainer


func _ready() -> void:
	self_modulate.a = 0
	material.set("shader_param/columns", 128)
	material.set("shader_param/rows", 72)
	hide()
	
func conf(_b : bool):
	if _b and !visible:
		$Tween.remove_all()
		$Tween.interpolate_property(self, "self_modulate:a", self_modulate.a, 1, 0.2, Tween.TRANS_BACK, Tween.EASE_IN)
		show()
		$Tween.start()
	if !_b and visible:
		$Tween.remove_all()
		$Tween.interpolate_property(self, "self_modulate:a", self_modulate.a, 0, 0.2, Tween.TRANS_BACK, Tween.EASE_IN)
		$Tween.start()
		yield($Tween,"tween_all_completed")
		hide()
