extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1909

var msg_sys = null

signal item_data_recived
signal spell_data_recived

func connect_to_server():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)

	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	
func _on_connection_failed():
	print("Failed to  connect")
	
func _on_connection_succeeded():
	print("Succesfully connected")
	fetch_item_data()
	msg_sys.update_text("fetching item database")
	yield(self, "item_data_recived")
	
	fetch_spell_data()
	msg_sys.update_text("fetching spell database")
	yield(self, "spell_data_recived")
	
	Main.get_game()

# GET DB
func fetch_item_data():
	rpc_id(1, "fetch_item_data")
	
remote func recive_item_data(item_data):
	DB.item_db = item_data
	emit_signal("item_data_recived")

func fetch_spell_data():
	rpc_id(1, "fetch_spell_data")
	
remote func recive_spell_data(spell_data):
	DB.spell_db = spell_data
	emit_signal("spell_data_recived")
