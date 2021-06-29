extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1909

signal db_recived

func connect_to_server():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)

	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	
func _on_connection_failed():
	print("Failed to  connect")
	
func _on_connection_succeeded():
	print("Succesfully connected")
	fetch_db()
	yield(self, "db_recived")
	Main.get_game()

# GET DB
func fetch_db():
	rpc_id(1, "fetch_db")
	
remote func recive_db(item_db, spell_db):
	DB.item_db = item_db
	DB.spell_db = spell_db
	emit_signal("db_recived")


