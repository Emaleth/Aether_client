extends PanelContainer

onready var compass = $Compass
onready var north = $Compass/N
onready var east = $Compass/E
onready var south = $Compass/S
onready var west = $Compass/W


func _ready() -> void:
	conf_compass()
	
func conf_compass() -> void:
	north.rect_position = Vector2(compass.rect_size.x / 2 - 20, -5)
	east.rect_position = Vector2(compass.rect_size.x - 35, compass.rect_size.y / 2 - 20)
	south.rect_position = Vector2(compass.rect_size.x / 2 - 20, compass.rect_size.y - 35)
	west.rect_position = Vector2(-5, compass.rect_size.y / 2 - 20)


func _on_ViewportContainer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			Input.action_press("map")
			
func _process(delta: float) -> void:
	for i in compass.get_children():
		$MarginContainer2/Border.rect_rotation = compass.rect_rotation
		i.rect_rotation = -compass.rect_rotation
