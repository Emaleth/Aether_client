extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1909

var msg_sys = null

var token
var latency = 0
var client_clock = 0
var delta_latency = 0
var latency_array = []
var decimal_collector : float = 0

signal spawn_player
signal despawn_player


func _physics_process(delta: float) -> void:
	client_clock += int(delta * 1000) + delta_latency
	delta_latency = 0
	decimal_collector += (delta * 1000) - int(delta * 1000)
	if decimal_collector >= 1.00:
		client_clock += 1
		decimal_collector -= 1.00
	
func connect_to_server():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)

	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	
func _on_connection_failed():
	pass
	
func _on_connection_succeeded():
	rpc_id(1, "fetch_server_time", OS.get_system_time_msecs())
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.autostart = true
	timer.connect("timeout", self, "determine_latency")
	self.add_child(timer)
	
remote func return_server_time(server_time, client_time):
	if get_tree().get_rpc_sender_id() == 1:
		latency = (OS.get_system_time_msecs() - client_time) / 2
		client_clock = server_time + latency
	
func determine_latency():
	rpc_id(1, "determine_latency", OS.get_system_time_msecs())
	
remote func return_latency(client_time):
	if get_tree().get_rpc_sender_id() == 1:
		latency_array.append((OS.get_system_time_msecs() - client_time) / 2)
		if latency_array.size() == 9:
			var total_latency = 0
			latency_array.sort()
			var mid_point = latency_array[4]
			for i in range(latency_array.size() -1, -1, -1):
				if latency_array[i] > (2 * mid_point) and latency_array[i] > 20:
					latency_array.remove(i)
				else:
					total_latency += latency_array[i]
			delta_latency = (total_latency / latency_array.size()) - latency
			latency = total_latency / latency_array.size()
#			print("New latency: ", latency)
#			print("New delta latency: ", delta_latency)
			latency_array.clear()
	
	
remote func fetch_token():
	if get_tree().get_rpc_sender_id() == 1:
		rpc_id(1, "return_token", token)
	
remote func return_token_verification_results(result):
	if get_tree().get_rpc_sender_id() == 1:
		if result == true:
			Main.get_game()
			yield(get_tree().create_timer(1),"timeout")
			get_node("../World/Actors/Actor").set_physics_process(true)
		else:
			pass


remote func spawn_new_player(player_id, position):
	if get_tree().get_rpc_sender_id() == 1:
		emit_signal("spawn_player", player_id, position)
		
remote func despawn_new_player(player_id):
	if get_tree().get_rpc_sender_id() == 1:
		emit_signal("despawn_player", player_id)
