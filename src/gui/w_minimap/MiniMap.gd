extends PanelContainer

onready var compass = $Compass
onready var north = $Compass/N
onready var east = $Compass/E
onready var south = $Compass/S
onready var west = $Compass/W


func _ready() -> void:
	conf_compass()
	
func conf_compass() -> void:
	north.rect_position = Vector2(compass.rect_size.x / 2 - 20, 0)
	east.rect_position = Vector2(compass.rect_size.x - 40, compass.rect_size.y / 2 - 20)
	south.rect_position = Vector2(compass.rect_size.x / 2 - 20, compass.rect_size.y - 40)
	west.rect_position = Vector2(0, compass.rect_size.y / 2 - 20)


func _on_ViewportContainer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			Input.action_press("map")
			
func _process(delta: float) -> void:
	for i in compass.get_children():
		i.rect_rotation = -compass.rect_rotation
