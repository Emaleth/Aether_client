extends Area


func _process(_delta: float) -> void:
	get_interactables()
	

func interact():
	if GlobalVariables.interactable != null:
		if GlobalVariables.interactable.is_in_group("loot"):
			Server.request_loot_pickup(GlobalVariables.interactable.name)
		elif GlobalVariables.interactable.is_in_group("res"):
			Server.request_loot_pickup(GlobalVariables.interactable.name)
		elif GlobalVariables.interactable.is_in_group("shop"):
			GlobalVariables.user_interface.set_mode(GlobalVariables.user_interface.SHOP)


func get_interactables():
	var interactables := []
	var nearest_interactable = null
	
	for i in get_overlapping_bodies():
		if i.is_in_group("shop") or i.is_in_group("loot") or i.is_in_group("res"):
			interactables.append(i)
			
	if interactables.size() != 0:
		var closest_distance := 0.0
		for i in interactables:
			if closest_distance <= 0:
				nearest_interactable = i
				closest_distance = i.global_transform.origin.distance_to(global_transform.origin)
			elif i.global_transform.origin.distance_to(global_transform.origin) < closest_distance:
				nearest_interactable = i
				closest_distance = i.global_transform.origin.distance_to(global_transform.origin)

	GlobalVariables.interactable = nearest_interactable if nearest_interactable != null else null
	
