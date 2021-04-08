extends CanvasLayer

onready var nesw : Control = $MiniMap/Compass


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("map"):
		if $MiniMap.visible == true:
			$MiniMap.hide()
			$Map.show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			$MiniMap.show()
			$Map.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_pressed("inventory"):
		if $Inventory.visible == false:
			$Inventory.show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			$Inventory.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
			
