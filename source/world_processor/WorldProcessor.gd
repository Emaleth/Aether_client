extends Node

const interpolation_offset = 100 # milliseconds

var last_fast_world_state := 0.0
var fast_world_state_buffer = []

onready var fast_processor = $Fast

func _ready():
	GlobalVariables.world = self
	Server.connect("sig_update_fast_world_state", self, "update_fast_world_state")
	fast_processor.configure($PlayerContainer, $NPCContainer, $AbilityContainer)

func _physics_process(_delta: float) -> void:
	interpolate_or_extrapolate()


func update_fast_world_state(_world_state):
	if float(_world_state[0]) > last_fast_world_state:
		last_fast_world_state = _world_state[0]
		fast_world_state_buffer.append(_world_state)


func interpolate_or_extrapolate():
	var render_time = Server.client_clock - interpolation_offset
	if fast_world_state_buffer.size() > 1:
		while fast_world_state_buffer.size() > 2 and render_time > float(fast_world_state_buffer[2][0]):
			fast_world_state_buffer.remove(0)

		if fast_world_state_buffer.size() > 2:
			fast_processor.interpolate(render_time, fast_world_state_buffer)
#			$NPCProcessor.interpolate(render_time, fast_world_state_buffer)
#			$PCProcessor.interpolate(render_time, fast_world_state_buffer)
#			$AbilityProcessor.interpolate(render_time, fast_world_state_buffer)
#
##			$LootProcessor.process_data()
##			$ShopProcessor.process_data()
#			$ResNodeProcessor.process_data()

		elif render_time > float(fast_world_state_buffer[1][0]):
			fast_processor.extrapolate(render_time, fast_world_state_buffer)
#			$NPCProcessor.extrapolate(render_time, fast_world_state_buffer)
#			$PCProcessor.extrapolate(render_time, fast_world_state_buffer)
#			$AbilityProcessor.extrapolate(render_time, fast_world_state_buffer)



