extends Spatial

var goods := []
func _ready() -> void:
	add_to_group("shop")
func update(new_position, _goods):
	transform.origin = new_position
	goods = _goods

