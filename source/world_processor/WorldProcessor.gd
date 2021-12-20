extends Node

const interpolation_offset = 100 # milliseconds

var last_world_state := 0.0
var world_state_buffer = []


func _ready():
	GlobalVariables.world = self
	Server.connect("s_update_world_state", self, "update_world_state")


func _physics_process(_delta: float) -> void:
	interpolate_or_extrapolate()


func update_world_state(_world_state):
	if float(_world_state["T"]) > last_world_state:
		last_world_state = _world_state["T"]
		world_state_buffer.append(_world_state)


func interpolate_or_extrapolate():
	var render_time = Server.client_clock - interpolation_offset
	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > float(world_state_buffer[2]["T"]):
			world_state_buffer.remove(0)

		if world_state_buffer.size() > 2:
			$NPCProcessor.interpolate(render_time, world_state_buffer)
			$PCProcessor.interpolate(render_time, world_state_buffer)
			$AbilityProcessor.interpolate(render_time, world_state_buffer)
		
			$LootProcessor.process_data()

		elif render_time > float(world_state_buffer[1]["T"]):
			$NPCProcessor.extrapolate(render_time, world_state_buffer)
			$PCProcessor.extrapolate(render_time, world_state_buffer)
			$AbilityProcessor.extrapolate(render_time, world_state_buffer)



