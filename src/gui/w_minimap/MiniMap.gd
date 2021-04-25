extends PanelContainer

onready var compass = $Compass
onready var north = $Compass/N
onready var east = $Compass/E
onready var south = $Compass/S
onready var west = $Compass/W


func _ready() -> void:
	conf_compass()
	
func conf_compass() -> void:
	north.rect_position = Vector2(compass.rect_size.x / 2 - 10, 0)
	east.rect_position = Vector2(compass.rect_size.x - 20, compass.rect_size.y / 2 - 10)
	south.rect_position = Vector2(compass.rect_size.x / 2 - 10, compass.rect_size.y - 20)
	west.rect_position = Vector2(0, compass.rect_size.y / 2 - 10)


func _on_ViewportContainer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			Input.action_press("map")
