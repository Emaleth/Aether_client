extends KinematicBody

onready var name_plate = $NamePlate


func _ready() -> void:
	add_to_group("Actor")
	$DEBUG_Body.get("material/0").next_pass.set("shader_param/outline_color", Color.transparent)
	
func update(new_position, new_rotation, _res):
	transform.origin = new_position
	transform.basis = new_rotation
	name_plate.update_health_bar(_res["health"]["current"], _res["health"]["max"])

func _on_NPC_mouse_entered() -> void:
	$DEBUG_Body.get("material/0").next_pass.set("shader_param/outline_color", Color.red)

func _on_NPC_mouse_exited() -> void:
	$DEBUG_Body.get("material/0").next_pass.set("shader_param/outline_color", Color.transparent)

