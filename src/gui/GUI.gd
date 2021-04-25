extends CanvasLayer

onready var nesw : Control = $MiniMap/Compass


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("map"):
		if $MiniMap.visible == true:
			$MiniMap.hide()
			$Map.show()
		else:
			$MiniMap.show()
			$Map.hide()
	if Input.is_action_just_pressed("inventory"):
		if $Inventory.visible == false:
			$Inventory.show()
		else:
			$Inventory.hide()

func conf(resources, minimap_camera_remote_transform):
	$Progress.health_bar.conf(tr("00006"), resources.health.maximum, resources.health.current, Color(1, 0, 0, 1))
	$Progress.mana_bar.conf(tr("00008"), resources.mana.maximum, resources.mana.current, Color(0, 0, 1, 1))
	$Progress.stamina_bar.conf(tr("00010"), resources.stamina.maximum, resources.stamina.current, Color(1, 1, 0, 1))
			
	minimap_camera_remote_transform.remote_path = $MiniMap/MarginContainer/ViewportContainer/Viewport/MiniMapCamera.get_path()
