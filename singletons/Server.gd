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
signal received_casting_time
signal received_chat


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
			fetch_item_data()
			msg_sys.update_text("fetching item database")
			yield(self, "item_data_returned")
			fetch_spell_data()
			msg_sys.update_text("fetching spell database")
			yield(self, "spell_data_returned")
			Main.get_game()
		else:
			pass
		
# ITEM DB
func fetch_item_data():
	rpc_id(1, "fetch_item_data")
	
remote func return_item_data(data):
	if get_tree().get_rpc_sender_id() == 1:
		DB.item_db = data
		emit_signal("item_data_returned")

# SPELL DB
func fetch_spell_data():
	rpc_id(1, "fetch_spell_data")
	
remote func return_spell_data(data):
	if get_tree().get_rpc_sender_id() == 1:
		DB.spell_db = data
		emit_signal("spell_data_returned")
	
# INVENTORY
func fetch_player_inventory():
	rpc_id(1, "fetch_player_inventory")
	
remote func return_player_inventory(data):
	if get_tree().get_rpc_sender_id() == 1:
		emit_signal("player_inventory_returned", data)

# EQUIPMENT
func fetch_player_equipment():
	rpc_id(1, "fetch_player_equipment")
	
remote func return_player_equipment(data):
	if get_tree().get_rpc_sender_id() == 1:
		emit_signal("player_equipment_returned", data)

# SPELLBOOK
func fetch_player_spellbook():
	rpc_id(1, "fetch_player_spellbook")
	
remote func return_player_spellbook(data):
	if get_tree().get_rpc_sender_id() == 1:
		emit_signal("player_spellbook_returned", data)

# RESOURCES
func fetch_player_resources():
	rpc_id(1, "fetch_player_resources")
	
remote func return_player_resources(data):
	if get_tree().get_rpc_sender_id() == 1:
		emit_signal("player_resources_returned", data)

# QUICKBAR
func fetch_player_quickbar():
	rpc_id(1, "fetch_player_quickbar")
	
remote func return_player_quickbar(data):
	if get_tree().get_rpc_sender_id() == 1:
		emit_signal("player_quickbar_returned", data)

# ATTRIBUTES
func fetch_player_attributes():
	rpc_id(1, "fetch_player_attributes")
	
remote func return_player_attributes(data):
	if get_tree().get_rpc_sender_id() == 1:
		emit_signal("player_attributes_returned", data)

# GENERAL
func fetch_player_general():
	rpc_id(1, "fetch_player_general")
	
remote func return_player_general(data):
	if get_tree().get_rpc_sender_id() == 1:
		emit_signal("player_general_returned", data)
	
# STATISTICS
func fetch_player_statistics():
	rpc_id(1, "fetch_player_statistics")
	
remote func return_player_statistics(data):
	if get_tree().get_rpc_sender_id() == 1:
		emit_signal("player_statistics_returned", data)
	
# SLOT MANAGEMENT
	
func request_slot_swap(source_slot = [], target_slot = []):
	rpc_id(1, "request_slot_swap", source_slot, target_slot)
	
func request_stack_split(source_slot = [], target_slot = [], quantity = 0):
	rpc_id(1, "request_stack_split", source_slot, target_slot, quantity)
	
func request_item_use(source_slot = []):
	rpc_id(1, "request_item_use", source_slot)
	
func request_spell_use(source_slot = []):
	rpc_id(1, "request_spell_use", source_slot)
	
func request_attribute_increase(attribute):
	rpc_id(1, "request_attribute_increase", attribute)

remote func received_casting_time(_time):
	if get_tree().get_rpc_sender_id() == 1:
		emit_signal("received_casting_time", _time)

func send_chat_msg(_text):
	rpc_id(1, "send_chat_msg", _text)
	
remote func receive_chat_msg(_array):
	if get_tree().get_rpc_sender_id() == 1:
		emit_signal("received_chat", _array)
