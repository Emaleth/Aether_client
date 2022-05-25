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
		dashboard.account_info.configure(_snapshot["account_id"])
	if _snapshot.has("resources_data"):
		hud.spells_and_resources.set_health_bar(_snapshot["resources_data"]["health"]["current"], _snapshot["resources_data"]["health"]["max"])
		hud.spells_and_resources.set_mana_bar(_snapshot["resources_data"]["mana"]["current"], _snapshot["resources_data"]["mana"]["max"])
		hud.spells_and_resources.set_stamina_bar(_snapshot["resources_data"]["stamina"]["current"], _snapshot["resources_data"]["stamina"]["max"])
	if _snapshot.has("currency_data"):
		pass
#		dashboard.currency
	if _snapshot.has("attributes_data"): 
		pass
#		dashboard.attributes_and_stats
	if _snapshot.has("equipment_data"): 
		dashboard.equipment.configure(_snapshot["equipment_data"])
	if _snapshot.has("abilities_data"): pass
	if _snapshot.has("action_bar_data"): pass
	if _snapshot.has("recipes_data"): pass
	if _snapshot.has("inventory_data"):
		dashboard.inventory.configure(_snapshot["inventory_data"])
