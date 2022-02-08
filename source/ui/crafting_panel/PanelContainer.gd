extends PanelContainer
	

func can_drop_data(_position: Vector2, _data) -> bool:
	return true
	
	
func drop_data(_position: Vector2, _data) -> void:
	Server.request_recipe_craft(_data)

	
