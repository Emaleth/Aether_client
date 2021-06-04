extends Node

var items = {
	"name" : {
		"scene" : null,#preload(""),
		"max_q" : 1000,
		"pool" : []
	}
}


#func _ready():
#	initiate_pools()
	
	
func initiate_pools():
	for i in items:
		for q in items.get(i).max_q:
			items.get(i).pool.append(items.get(i).scene.instance())
		
		
func get_item(obj):
	var first_item = items.get(obj).pool.pop_front()
	if first_item.get_parent():
		first_item.get_parent().remove_child(first_item)
	items.get(obj).pool.append(first_item)
	
	return first_item
