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
		"max_q" : 10,
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
			items.get(i).pool.append(new_item.get_instance_id())
			
func get_item(_type):
	var first_item = items.get(_type).pool.pop_front()
	items.get(_type).bussy.append(first_item)
	return instance_from_id(first_item)

func free_item(_type, _id):
	var item_index = items[_type]["bussy"].find(_id)
	var item = items[_type]["bussy"][item_index]
	instance_from_id(item).get_parent().remove_child(instance_from_id(item))
	items.get(_type).bussy.erase(_id)
	items.get(_type).pool.append(_id)
