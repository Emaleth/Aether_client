extends CanvasLayer

#onready var minimap : Control = $MiniMap


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
	$Progress.health_bar.conf(resources.health.maximum, resources.health.current, Color.red)
	$Progress.mana_bar.conf(resources.mana.maximum, resources.mana.current, Color.blue)
	$Progress.stamina_bar.conf(resources.stamina.maximum, resources.stamina.current, Color.orange)
			
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
		$TargetProgress.name_label.show()
		$TargetProgress.health_bar.conf(target.resources.health.maximum, target.resources.health.current, Color.red)
		$TargetProgress.mana_bar.conf(target.resources.mana.maximum, target.resources.mana.current, Color.blue)
		$TargetProgress.stamina_bar.conf(target.resources.stamina.maximum, target.resources.stamina.current, Color.orange)
		$TargetProgress.show()
	
func update_targe_info(res):
	$TargetProgress.health_bar.updt(res.health.current)
	$TargetProgress.mana_bar.updt(res.mana.current)
	$TargetProgress.stamina_bar.updt(res.stamina.current)

func configure_inv(actor):
	$Inventory.conf(actor)
	
func configure_eq(actor):
	$Equipment.conf(actor)
	
func configure_skillbar(actor):
	$SkillBar.conf(actor)
