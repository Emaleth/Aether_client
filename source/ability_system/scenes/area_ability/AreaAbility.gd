extends Area

onready var server = get_node("/root/Server")

onready var lifetime_timer := $LifetimeTimer
onready var tick_timer := $TickTimer

var caster_id : String
var offset : Vector3
var data : Array

onready var collision_shape := $CollisionShape


func configure(transform_array : Array, _data : Array, _caster_id : String):
	global_transform = transform_array[0]
	data = _data.duplicate(true)
	caster_id = _caster_id
	
	
func _physics_process(delta: float) -> void:
	if data[1]["caster_bound"] == true:
		if caster_id == str(get_tree().get_network_unique_id()):
			var caster_transform = GlobalVariables.player_actor.global_transform
			global_transform.basis = caster_transform.basis
			global_transform.origin = caster_transform.origin + offset
		else:
			var caster_transform = GlobalVariables.world.get_node("PlayerContainer/" + caster_id).global_transform
			global_transform.basis = caster_transform.basis
			global_transform.origin = caster_transform.origin + offset
	
func _ready() -> void:
	lifetime_timer.start(data[1]["lifetime"])
	tick_timer.start(data[1]["tick_time"])
	offset = Vector3(0, 0.9, 0) if data[1]["caster_bound"] == true else Vector3.ZERO
	tick() # fist tick
	
	
func tick():
	pass


func _on_TickTimer_timeout() -> void:
	tick()


func _on_LifetimeTimer_timeout() -> void:
	collision_shape.set_deferred("disabled", true)
	queue_free()
