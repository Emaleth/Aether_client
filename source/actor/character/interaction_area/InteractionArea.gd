extends Area


func _process(delta: float) -> void:
	get_interactables()
	

func interact():
	if GlobalVariables.interactable != null:
		if GlobalVariables.interactable.is_in_group("loot"):
			Server.request_loot_pickup(GlobalVariables.interactable.name)
		if GlobalVariables.interactable.is_in_group("shop"):
			GlobalVariables.user_interface.set_mode(GlobalVariables.user_interface.SHOP)


func get_interactables():
	var interactable = get_overlapping_bodies()
	var nearest_loot = null
	if interactable.size() != 0:
		var closest_distance = null
		for i in interactable:
			if closest_distance == null:
				nearest_loot = i
				closest_distance = i.global_transform.origin.distance_to(global_transform.origin)
			elif i.global_transform.origin.distance_to(global_transform.origin) < closest_distance:
				nearest_loot = i
				closest_distance = i.global_transform.origin.distance_to(global_transform.origin)
	GlobalVariables.interactable = nearest_loot if nearest_loot != null else null
	
