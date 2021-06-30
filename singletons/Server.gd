extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1909

var msg_sys = null

signal item_data_returned
signal spell_data_returned

signal player_inventory_returned
signal player_resources_returned
signal player_quickbar_returned
signal player_equipment_returned
signal player_spellbook_returned
signal player_statistics_returned
signal player_general_returned
signal player_attributes_returned

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
	yield(self, "item_data_returned")
	
	fetch_spell_data()
	msg_sys.update_text("fetching spell database")
	yield(self, "spell_data_returned")
	
	Main.get_game()

# ITEM DB
func fetch_item_data():
	rpc_id(1, "fetch_item_data")
	
remote func return_item_data(data):
	DB.item_db = data
	emit_signal("item_data_returned")

# SPELL DB
func fetch_spell_data():
	rpc_id(1, "fetch_spell_data")
	
remote func return_spell_data(data):
	DB.spell_db = data
	emit_signal("spell_data_returned")
	
# INVENTORY
func fetch_player_inventory():
	rpc_id(1, "fetch_player_inventory")
	
remote func return_player_inventory(data):
	emit_signal("player_inventory_returned", data)

# EQUIPMENT
func fetch_player_equipment():
	rpc_id(1, "fetch_player_equipment")
	
remote func return_player_equipment(data):
	emit_signal("player_equipment_returned", data)

# SPELLBOOK
func fetch_player_spellbook():
	rpc_id(1, "fetch_player_spellbook")
	
remote func return_player_spellbook(data):
	emit_signal("player_spellbook_returned", data)

# RESOURCES
func fetch_player_resources():
	rpc_id(1, "fetch_player_resources")
	
remote func return_player_resources(data):
	emit_signal("player_resources_returned", data)

# QUICKBAR
func fetch_player_quickbar():
	rpc_id(1, "fetch_player_quickbar")
	
remote func return_player_quickbar(data):
	emit_signal("player_quickbar_returned", data)

# ATTRIBUTES
func fetch_player_attributes():
	rpc_id(1, "fetch_player_attributes")
	
remote func return_player_attributes(data):
	emit_signal("player_attributes_returned", data)

# GENERAL
func fetch_player_general():
	rpc_id(1, "fetch_player_general")
	
remote func return_player_general(data):
	emit_signal("player_general_returned", data)
	
# STATISTICS
func fetch_player_statistics():
	rpc_id(1, "fetch_player_statistics")
	
remote func return_player_statistics(data):
	emit_signal("player_statistics_returned", data)
	
# SLOT MANAGEMENT
	
func request_slot_swap(source_slot = [], target_slot = []):
	rpc_id(1, "request_slot_swap", source_slot, target_slot)
	
func request_stack_split(source_slot = [], target_slot = [], quantity = 0):
	rpc_id(1, "request_stack_split")
func request_item_use(source_slot = []):
	rpc_id(1, "request_item_use")
func request_spell_use(source_slot = []):
	rpc_id(1, "request_spell_use")
func request_attribute_increase(attribute):
	rpc_id(1, "request_attribute_increase")
