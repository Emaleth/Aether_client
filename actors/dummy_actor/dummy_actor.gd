extends KinematicBody

var max_hp
var current_hp

onready var hp_label = $MeshInstance/Viewport/Label


func _ready() -> void:
	$MeshInstance.get("material/0").albedo_texture = $MeshInstance/Viewport.get_texture()

func update(new_position, new_rotation, _hp):
	transform.origin = new_position
	transform.basis = new_rotation
	if current_hp != _hp:
		current_hp = _hp
		update_label()
		
func update_label():
	hp_label.text = "%s / %s" % [current_hp, max_hp]

func configure(_max_hp):
	max_hp = _max_hp


