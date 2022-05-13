extends KinematicBody


var data : Dictionary = {}


func _ready() -> void:
	$Sprite3D.texture = $Sprite3D/Viewport.get_texture()
	process_data()
	
	
func configure(_data):
	data = _data


func process_data():
	print(str(data.keys()[0]))
	global_transform = data.values()[0]

	
func update(_data):
	for i in _data:
		data[i] = _data[i]
#	name_plate.update_health_bar(_data[0], data[1]["health"])


func move():
	pass
