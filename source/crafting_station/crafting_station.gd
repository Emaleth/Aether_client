extends StaticBody


func _ready() -> void:
	name = str(get_index())
	add_to_group("crafting_station")
