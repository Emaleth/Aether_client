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
			items.get(i).pool.append(items.get(i).scene.instance())
		
func get_item(obj):
	var first_item = items.get(obj).pool.pop_front()
	items.get(obj).bussy.append(first_item)
	return first_item

func free_item(obj, id):
	var object = items.get(obj).bussy.get(id)
	object.get_parent().remove_child(object)
	items.get(obj).bussy.erase(object)
	items.get(obj).pool.append(id)
