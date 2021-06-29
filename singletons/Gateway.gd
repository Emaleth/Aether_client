extends Node

var network : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
var gateway_api : MultiplayerAPI = MultiplayerAPI.new()
var ip : String = "127.0.0.1"
var port : int = 1910

var username
var password


func _process(delta: float) -> void:
	if not get_custom_multiplayer():
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
	
func connect_to_server(_username, _password):
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	username = _username
	password = _password
	network.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	
func _on_connection_failed():
	print("Failed to connect to Authentication server")
	
func _on_connection_succeeded():
	print("Succesfully connected to Authentication server")
	request_login()
	
func request_login():
	print("requesting login")
	rpc_id(1, "login_request", username, password)
	username = ""
	password = ""
	
remote func return_login_request(results):
	if results == true:
		Server.connect_to_server()
		print("logged in")
	else:
		print("loggin failed")
	network.disconnect("connection_failed", self, "_on_connection_failed")
	network.disconnect("connection_succeeded", self, "_on_connection_succeeded")
	
	
