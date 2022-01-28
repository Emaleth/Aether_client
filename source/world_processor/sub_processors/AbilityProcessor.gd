extends Node

var collection = {}
var container = self

onready var dummy_bullet_scene = preload("res://source/projectile/dummyBullet.tscn")


func _physics_process(_delta: float) -> void:
	add_to_the_tree()
	update_in_the_tree()
	remove_from_the_tree()


func add_to_the_tree():
	for bullet in collection.keys():
		if not container.has_node(str(bullet)):
#			if collection[bullet]["p_id"] == str(get_tree().get_network_unique_id()):
#				continue
			var new_bullet = dummy_bullet_scene.instance()
			new_bullet.name = str(bullet)
			new_bullet.transform.origin = collection[bullet]["pos"]
			new_bullet.transform.basis = collection[bullet]["rot"]
			new_bullet.ability = collection[bullet]["ability"]
			container.add_child(new_bullet, true)


func update_in_the_tree():
	for bullet in container.get_children():
		if collection.has(bullet.name):
			bullet.update(collection[bullet.name]["pos"], collection[bullet.name]["rot"])


func remove_from_the_tree():
	for bullet in container.get_children():
		if not collection.has(bullet.name):
			bullet.queue_free()


func add_to_the_collection(_id, _data):
	collection[_id] = _data


func update_inside_the_collection(_id, _data):
	for key in _data.keys():
		collection[_id][key] = _data[key]


func remove_from_the_collection(_id):
	collection.erase(_id)


func interpolate(_render_time, world_state_buffer):
	var interpolation_factor = float(_render_time - world_state_buffer[1]["T"]) / float(world_state_buffer[2]["T"] - world_state_buffer[1]["T"])

	for bullet in world_state_buffer[2]["B"].keys():
		if not world_state_buffer[1]["B"].has(bullet): # WE WANT TO BE SURE THAT BOTH WS1 AND WS2 HAVE ANY GIVEN KEY FOR INTERPOLATION'S SAKE
			continue
		if collection.has(bullet):
			var modified_data := {}
			modified_data = world_state_buffer[2]["B"][bullet].duplicate(true)
			modified_data["pos"] = lerp(world_state_buffer[1]["B"][bullet]["pos"], world_state_buffer[2]["B"][bullet]["pos"], interpolation_factor)
			var current_rot = (world_state_buffer[1]["B"][bullet]["rot"]).get_rotation_quat()
			var target_rot = (world_state_buffer[2]["B"][bullet]["rot"]).get_rotation_quat()
			modified_data["rot"] = Basis(current_rot.slerp(target_rot, interpolation_factor))
			update_inside_the_collection(bullet, modified_data)
		else:
			add_to_the_collection(bullet, world_state_buffer[2]["B"][bullet])
	for bullet in collection:
		if not world_state_buffer[2]["B"].keys().has(bullet):
			remove_from_the_collection(bullet)


func extrapolate(_render_time, world_state_buffer):
	var extrapolation_factor = float(_render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.00

	for bullet in world_state_buffer[1]["B"].keys():
		if not world_state_buffer[0]["B"].has(bullet): # WE WANT TO BE SURE THAT BOTH WS0 AND WS1 HAVE ANY GIVEN KEY FOR EXTRAPOLATION'S SAKE
			continue
		if collection.has(bullet):
			var modified_data := {}
			var position_delta = (world_state_buffer[1]["B"][bullet]["pos"] - world_state_buffer[0]["B"][bullet]["pos"])
			modified_data["pos"] = world_state_buffer[1]["B"][bullet]["pos"] + (position_delta * extrapolation_factor)
			var current_rot = (world_state_buffer[1]["B"][bullet]["rot"]).get_rotation_quat()
			var old_rot = (world_state_buffer[0]["B"][bullet]["rot"]).get_rotation_quat()
			var rotation_delta = (current_rot - old_rot)
			modified_data["rot"] = Basis(current_rot + (rotation_delta * extrapolation_factor))
			update_inside_the_collection(bullet, modified_data)

