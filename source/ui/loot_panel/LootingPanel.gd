extends PanelContainer

onready var slot = preload("res://source/ui/subcomponents/slots/loot_slot/LootSlot.tscn")
onready var slot_grid = $GridContainer


func configure(_data : Array, _npc_id : int):
#	print("configurinf looting panel")
	var index = 0
	for i in slot_grid.get_children():
		i.hide()
		i.queue_free()
	for i in _data:
		var new_slot = slot.instance()
		slot_grid.add_child(new_slot)
		new_slot.configure(i, _npc_id, index)
		index += 1
		
	
#func _ready() -> void:
#	configure(GlobalVariables.tmp_loot_data, GlobalVariables.tmp_loot_name)

