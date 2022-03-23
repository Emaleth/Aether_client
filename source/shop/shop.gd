extends StaticBody


var shop_id := "test_shop"


func _ready() -> void:
	name = str(get_index())
	add_to_group("shop")
	
