extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1909

# verification token
var token
# clock sync
var latency = 0
var client_clock = 0
var delta_latency = 0
var latency_array = []
var decimal_collector : float = 0
# signals
signal s_token_verification_success
signal s_token_verification_failure
signal s_update_world_state
signal s_update_chat_state

signal update_inventory_ui
signal update_pouch_ui
signal update_equipment_ui
signal update_spellbook_ui
signal update_currency_ui


func _physics_process(delta: float) -> void:
	clock_decimal_precision(delta)
	
	
func clock_decimal_precision(_delta):
	client_clock += int(_delta * 1000) + delta_latency
	delta_latency = 0
	decimal_collector += (_delta * 1000) - int(_delta * 1000)
	if decimal_collector >= 1.00:
		client_clock += 1
		decimal_collector -= 1.00
	
	
func connect_to_server():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)

	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	
	
func _on_connection_failed():
	print("Could not connect to the Server!")
	
	
func _on_connection_succeeded():
	get_server_time()
	var server_clock_sync_timer = Timer.new()
	server_clock_sync_timer.wait_time = 5
	server_clock_sync_timer.autostart = true
	server_clock_sync_timer.connect("timeout", self, "get_server_time")
	self.add_child(server_clock_sync_timer)
	determine_latency()
	var latency_timer = Timer.new()
	latency_timer.wait_time = 0.5
	latency_timer.autostart = true
	latency_timer.connect("timeout", self, "determine_latency")
	self.add_child(latency_timer)
	
	
remote func return_server_time(server_time, client_time):
	if get_tree().get_rpc_sender_id() == 1:
		latency = (OS.get_system_time_msecs() - client_time) / 2
		client_clock = server_time + latency
#	print("clock re-sync")
	
	
func get_server_time():
	rpc_id(1, "fetch_server_time", OS.get_system_time_msecs())
	
	
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
			latency_array.clear()
	
	
remote func fetch_token():
	if get_tree().get_rpc_sender_id() == 1:
		rpc_id(1, "return_token", token)
	
	
remote func return_token_verification_results(result):
	if get_tree().get_rpc_sender_id() == 1:
		if result == true:
			emit_signal("s_token_verification_success")
		else:
			emit_signal("s_token_verification_failure")
	
	
remote func recive_world_state(world_state):
	if get_tree().get_rpc_sender_id() == 1:
		emit_signal("s_update_world_state", world_state)


func send_chat_message(_message):
	rpc_unreliable_id(1, "recive_chat_message", client_clock, _message)
	
	
remote func recive_chat_state(chat_state):
	if get_tree().get_rpc_sender_id() == 1:
		emit_signal("s_update_chat_state", chat_state)


func send_item_use_request(_data : Dictionary):
	rpc_id(1, "request_item_use", _data)
	
	
func send_weapon_use_request(_mode : String):
	rpc_id(1, "request_weapon_use", _mode)
	
	
func send_player_state(_position : Vector3, _rotation : Basis, _aim : Vector3):
	rpc_unreliable_id(1, "recive_player_state", _position, _rotation, _aim)
	

remote func receive_data_tables(_data : Dictionary):
	if get_tree().get_rpc_sender_id() == 1:
		LocalDataTables.item_table = _data["item_table"]
		LocalDataTables.enemy_table = _data["enemy_table"]
		LocalDataTables.skill_table = _data["skill_table"]
	
	
remote func recive_equipment_data(_data : Dictionary):
	if get_tree().get_rpc_sender_id() == 1:
		GlobalVariables.equipment_data = _data
		emit_signal("update_equipment_ui", _data)


remote func recive_inventory_data(_data : Array):
	if get_tree().get_rpc_sender_id() == 1:
		GlobalVariables.inventory_data = _data
		emit_signal("update_inventory_ui", _data)


remote func recive_pouch_data(_data : Array):
	if get_tree().get_rpc_sender_id() == 1:
		GlobalVariables.pouch_data = _data
		emit_signal("update_pouch_ui", _data)


remote func recive_spellbook_data(_data : Array):
	if get_tree().get_rpc_sender_id() == 1:
		GlobalVariables.spellbook_data = _data
		emit_signal("update_spellbook_ui", _data)
		
		
func request_item_transfer(_from_data : Dictionary, _amount : int, _to_data : Dictionary):
	rpc_id(1, "request_item_transfer", _from_data, _amount, _to_data)
	
	
func request_loot_pickup(_loot_id : String):
	rpc_id(1, "request_loot_pickup", _loot_id)
	
	
func request_loot_drop(_loot_id : String):
	rpc_id(1, "request_loot_drop", _loot_id)
	
	
func request_item_buy(_shop_id : String, _slot_index : int):
	rpc_id(1, "request_item_buy", _shop_id, _slot_index)
	
	
func request_item_sell(_shop_id : String, _container : String, _slot_index : int):
	rpc_id(1, "request_item_sell", _shop_id, _container, _slot_index)
