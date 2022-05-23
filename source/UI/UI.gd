extends PanelContainer

onready var dashboard := $Dashboard
onready var hud := $HUD


func _ready() -> void:
	dashboard.hide()


func show_hud():
	hud.show()


func open_dashboard():
	dashboard.show()


func process_private_snapshot(_snapshot):
	if _snapshot.has("account_id"): 
		print(_snapshot["account_id"])
	if _snapshot.has("resources_data"):
		$HUD/SpellzAndStuff.set_health_bar(_snapshot["resources_data"]["health"]["current"], _snapshot["resources_data"]["health"]["max"])
		$HUD/SpellzAndStuff.set_mana_bar(_snapshot["resources_data"]["mana"]["current"], _snapshot["resources_data"]["mana"]["max"])
		$HUD/SpellzAndStuff.set_stamina_bar(_snapshot["resources_data"]["stamina"]["current"], _snapshot["resources_data"]["stamina"]["max"])
	if _snapshot.has("currency_data"): pass
	if _snapshot.has("attributes_data"): pass
	if _snapshot.has("equipment_data"): pass
	if _snapshot.has("abilities_data"): pass
	if _snapshot.has("action_bar_data"): pass
	if _snapshot.has("recipes_data"): pass
	if _snapshot.has("inventory_data"):
		$Dashboard/Bg/HBoxContainer/MiddleContainer/RightSector/Inventory.configure(_snapshot["inventory_data"])
