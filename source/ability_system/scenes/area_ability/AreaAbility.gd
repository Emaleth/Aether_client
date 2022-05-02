extends Area

onready var server = get_node("/root/Server")

onready var lifetime_timer := $LifetimeTimer
onready var tick_timer := $TickTimer

var caster_id : String
var data : Array

onready var collision_shape := $CollisionShape


func configure(transform_array : Array, _data : Array):
	global_transform = transform_array[0]
	data = _data.duplicate(true)
	
	
func _ready() -> void:
	lifetime_timer.start(data[1]["lifetime"])
	tick_timer.start(data[1]["tick_time"])
	tick() # fist tick
	
	
func tick():
	pass


func _on_TickTimer_timeout() -> void:
	tick()


func _on_LifetimeTimer_timeout() -> void:
	collision_shape.set_deferred("disabled", true)
	queue_free()
