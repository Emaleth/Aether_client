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
	if Input.is_action_just_pressed("character"):
		if $Equipment.visible == false:
			$Equipment.show()
		else:
			$Equipment.hide()

func conf(resources, minimap_camera_remote_transform):
	$Progress.health_bar.conf(tr("00006"), resources.health.maximum, resources.health.current, Color(1, 0, 0, 1))
	$Progress.mana_bar.conf(tr("00008"), resources.mana.maximum, resources.mana.current, Color(0, 0, 1, 1))
	$Progress.stamina_bar.conf(tr("00010"), resources.stamina.maximum, resources.stamina.current, Color(1, 1, 0, 1))
			
	minimap_camera_remote_transform.remote_path = $MiniMap/MarginContainer/ViewportContainer/Viewport/MiniMapCamera.get_path()

func update_gui(res):
	$Progress.health_bar.updt(res.health.current)
	$Progress.mana_bar.updt(res.mana.current)
	$Progress.stamina_bar.updt(res.stamina.current)
	
func get_target_info(target, yay_or_nay):
	if yay_or_nay == false:
		$TargetProgress.hide()
	else:
		$TargetProgress.name_label.text = target.statistics.name
		$TargetProgress.lvl_label.text = target.statistics.level
#		$TargetProgress.class_texture.texture = load("res://icon.png")
		$TargetProgress.target_stuff.show()
		$TargetProgress.health_bar.conf(tr("00006"), target.resources.health.maximum, target.resources.health.current, Color(1, 0, 0, 1))
		$TargetProgress.mana_bar.conf(tr("00008"), target.resources.mana.maximum, target.resources.mana.current, Color(0, 0, 1, 1))
		$TargetProgress.stamina_bar.conf(tr("00010"), target.resources.stamina.maximum, target.resources.stamina.current, Color(1, 1, 0, 1))
		$TargetProgress.show()
	
func update_targe_info(res):
	$TargetProgress.health_bar.updt(res.health.current)
	$TargetProgress.mana_bar.updt(res.mana.current)
	$TargetProgress.stamina_bar.updt(res.stamina.current)

func configure_inv(inv):
	$Inventory.conf(inv)
	
func configure_eq(eq):
	$Equipment.conf(eq)
