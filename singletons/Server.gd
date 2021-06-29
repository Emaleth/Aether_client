extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1909

	
func connect_to_server():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)

	
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	
func _on_connection_failed():
	print("Failed to  connect")
	
func _on_connection_succeeded():
	print("Succesfully connected")
