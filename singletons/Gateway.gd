extends Node

var network : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
var gateway_api : MultiplayerAPI = MultiplayerAPI.new()
var ip : String = "127.0.0.1"
var port : int = 1910
var cert = load("res://X509_Certificate.crt")

var username
var password
var new_account


func _process(delta: float) -> void:
	if not get_custom_multiplayer():
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
	
func connect_to_server(_username, _password, _new_account):
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	network.set_dtls_enabled(true)
	network.set_dtls_verify_enabled(false)
	network.set_dtls_certificate(cert)
	username = _username
	password = _password
	new_account = _new_account
	network.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	
func _on_connection_failed():
	pass
	
func _on_connection_succeeded():
	if new_account == true:
		request_create_account()
	else:
		request_login()
	
func request_login():
	rpc_id(1, "login_request", username, password.sha256_text())
	username = ""
	password = ""
	
func request_create_account():
	rpc_id(1, "create_account_request", username, password.sha256_text())
	username = ""
	password = ""
	
remote func return_login_request(results, token):
	if results == true:
		Server.token = token
		Server.connect_to_server()
		print("logged in")
	else:
		print("loggin failed")
	network.disconnect("connection_failed", self, "_on_connection_failed")
	network.disconnect("connection_succeeded", self, "_on_connection_succeeded")
	
remote func return_create_account_request(results, message):
	if results == true:
		print("account created, please log in")
	else:
		if message == 1:
			print("couldnt create an account, please try again")
		if message == 2:
			print("username already exists")
	network.disconnect("connection_failed", self, "_on_connection_failed")
	network.disconnect("connection_succeeded", self, "_on_connection_succeeded")