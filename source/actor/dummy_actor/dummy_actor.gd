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
	if !GlobalVariables.target == self:
		$DEBUG_Body.get("material/0").next_pass.set("shader_param/outline_color", Color.yellow)

func _on_NPC_mouse_exited() -> void:
	if !GlobalVariables.target == self:
		$DEBUG_Body.get("material/0").next_pass.set("shader_param/outline_color", Color.transparent)

func _on_NPC_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if GlobalVariables.target:
			GlobalVariables.target.get_node("DEBUG_Body").get("material/0").next_pass.set("shader_param/outline_color", Color.transparent)
		GlobalVariables.target = self
		$DEBUG_Body.get("material/0").next_pass.set("shader_param/outline_color", Color.red)

