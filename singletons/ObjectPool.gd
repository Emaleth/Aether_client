extends Node

var items = {
	"dummy" : {
		"scene" : preload("res://actors/dummy/Dummy.tscn"),
		"max_q" : 100,
		"pool" : [],
		"bussy" : []
	},
	"npc" : {
		"scene" : preload("res://actors/npc/NPC.tscn"),
		"max_q" : 100,
		"pool" : [],
		"bussy" : []
	}
}


func _ready():
	initiate_pools()
	
func initiate_pools():
	for i in items:
		for q in items.get(i).max_q:
			var new_item = items.get(i).scene.instance()
			items.get(i).pool.append(new_item)
			new_item.pool_ref = str(new_item)
			
		
func get_item(_type):
	var first_item = items.get(_type).pool.pop_front()
	items.get(_type).bussy.append(first_item)
	return first_item

func free_item(_type, _id):
	var object = items[_type]["bussy"][_id]
	object.get_parent().remove_child(object)
	items.get(_type).bussy.erase(object)
	items.get(_type).pool.append(_id)
