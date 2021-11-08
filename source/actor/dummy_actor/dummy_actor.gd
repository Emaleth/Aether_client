extends KinematicBody

onready var name_plate = $NamePlate


func _ready() -> void:
	add_to_group("Actor")
	
func update(new_position, new_rotation, _res):
	transform.origin = new_position
	transform.basis = new_rotation
	name_plate.update_health_bar(_res["health"]["current"], _res["health"]["max"])

func _on_NPC_mouse_entered() -> void:
	$DEBUG_Body.get("material/0").albedo_color = Color.red
#	Input.set_custom_mouse_cursor(load("res://assets/cursors/broad-dagger.png"))
#	Input.hotspot

func _on_NPC_mouse_exited() -> void:
	$DEBUG_Body.get("material/0").albedo_color = Color.whitesmoke
#	Input.set_custom_mouse_cursor(load("res://assets/cursors/crosshair070.png"))
