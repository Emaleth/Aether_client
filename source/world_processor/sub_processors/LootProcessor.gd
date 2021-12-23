extends Node

var collection = {}
var container = self

onready var loot_scene = preload("res://source/dummy_loot/DummyLoot.tscn")


func _physics_process(_delta: float) -> void:
	add_to_the_tree()
	remove_from_the_tree()

	
func add_to_the_tree():
	for key in collection.keys():
		if not container.has_node(str(key)):
			var new_loot = loot_scene.instance()
			new_loot.name = str(key)
			container.call_deferred("add_child", new_loot, true)
			new_loot.update(collection[key]["pos"])
			

func remove_from_the_tree():
	for npc in container.get_children():
		if not collection.has(str(npc.name)):
			npc.call_deferred("queue_free")


func add_to_the_collection(_id, _data):
	collection[_id] = _data


func remove_from_the_collection(_id):
	collection.erase(_id)


func process_data():
	var wsb2_loot = get_parent().world_state_buffer[2]["L"]
	for npc in wsb2_loot.keys():
		if not collection.has(npc):
			add_to_the_collection(npc, wsb2_loot[npc])
	
	for npc in collection:
		if not wsb2_loot.keys().has(npc):
			remove_from_the_collection(npc)
