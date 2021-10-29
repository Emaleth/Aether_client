extends KinematicBody

onready var name_plate = $NamePlate


func _ready() -> void:
	add_to_group("Actor")
	
func update(new_position, new_rotation, _hp, _max_hp):
	transform.origin = new_position
	transform.basis = new_rotation
	name_plate.update_health_bar(_hp, _max_hp)

func _on_NPC_mouse_entered() -> void:
	$DEBUG_Body.get("material/0").albedo_color = Color.red

func _on_NPC_mouse_exited() -> void:
	$DEBUG_Body.get("material/0").albedo_color = Color.whitesmoke
