extends Button

var item = null
var amount = null

onready var amount_label = $AmountLabel
onready var cooldown_overlay = $CooldownOverlay
onready var cooldown_label = $CooldownLabel


func _ready() -> void:
	amount_label.hide()
	cooldown_label.hide()
	cooldown_overlay.hide()

func _on_Tween_tween_step(object: Object, key: NodePath, elapsed: float, value: Object) -> void:
	pass # Replace with function body.

func _on_Slot_pressed() -> void:
	pass # Replace with function body.

func cooldown_animation():
	pass

func get_drag_data(position: Vector2):
	pass

func can_drop_data(position: Vector2, data) -> bool:
	return true

func drop_data(position: Vector2, data) -> void:
	pass
	
