tool
extends Spatial
# GENERATE
export(bool) var generate_world := false
export(bool) var extract_collisions := false
export(int, 0, 1000) var density = 0
export(int) var extents = 0
export(float) var water_level = 0.0

var a := {
	"assets" : [
		preload("res://source/environment/nature/bushes/bush01.tscn"),
		preload("res://source/environment/nature/bushes/bush02.tscn"),
		preload("res://source/environment/nature/bushes/bush03.tscn"),
		preload("res://source/environment/nature/bushes/bush04.tscn"),
		preload("res://source/environment/nature/bushes/bush05.tscn"),
		preload("res://source/environment/nature/bushes/bush06.tscn"),
		preload("res://source/environment/nature/bushes/bush07.tscn"),
		preload("res://source/environment/nature/bushes/bush08.tscn"),
	],
	"weight" : 3
}

var b := {
	"assets" : [
		preload("res://source/environment/nature/trees/tree01.tscn"),
		preload("res://source/environment/nature/trees/tree02.tscn"),
		preload("res://source/environment/nature/trees/tree03.tscn"),
		preload("res://source/environment/nature/trees/tree04.tscn"),
		preload("res://source/environment/nature/trees/tree05.tscn"),
		preload("res://source/environment/nature/trees/tree06.tscn"),
		preload("res://source/environment/nature/trees/tree07.tscn"),
		preload("res://source/environment/nature/trees/tree08.tscn"),
		preload("res://source/environment/nature/trees/tree09.tscn"),
		preload("res://source/environment/nature/trees/tree10.tscn"),
		preload("res://source/environment/nature/trees/tree11.tscn"),
		preload("res://source/environment/nature/trees/tree12.tscn"),
		preload("res://source/environment/nature/trees/tree13.tscn"),
		preload("res://source/environment/nature/trees/tree14.tscn"),
		preload("res://source/environment/nature/trees/tree15.tscn"),
		preload("res://source/environment/nature/trees/tree16.tscn"),
		preload("res://source/environment/nature/trees/tree17.tscn"),
		preload("res://source/environment/nature/trees/tree18.tscn"),
		preload("res://source/environment/nature/trees/tree19.tscn"),
		preload("res://source/environment/nature/trees/tree20.tscn"),
		preload("res://source/environment/nature/trees/tree21.tscn"),
		preload("res://source/environment/nature/trees/tree22.tscn"),
		preload("res://source/environment/nature/trees/tree23.tscn"),
		preload("res://source/environment/nature/trees/tree24.tscn"),
		preload("res://source/environment/nature/trees/tree25.tscn"),
		preload("res://source/environment/nature/trees/tree26.tscn"),
		preload("res://source/environment/nature/trees/tree27.tscn"),
		preload("res://source/environment/nature/trees/tree28.tscn"),
		preload("res://source/environment/nature/trees/tree29.tscn"),
		preload("res://source/environment/nature/trees/tree30.tscn"),
		preload("res://source/environment/nature/trees/tree31.tscn"),
		preload("res://source/environment/nature/trees/tree32.tscn"),
		preload("res://source/environment/nature/trees/tree33.tscn"),
		preload("res://source/environment/nature/trees/tree34.tscn"),
		preload("res://source/environment/nature/trees/tree35.tscn"),
		preload("res://source/environment/nature/trees/tree36.tscn"),
	],
	"weight" : 5
}

var c := {
	"assets" : [
		preload("res://source/environment/nature/rocks/rock_handpainted_1.tscn"),
		preload("res://source/environment/nature/rocks/rock_handpainted_2.tscn"),
		preload("res://source/environment/nature/rocks/rock_handpainted_3.tscn"),
		preload("res://source/environment/nature/rocks/rock_handpainted_4.tscn"),
		preload("res://source/environment/nature/rocks/rock_handpainted_5.tscn"),
	],
	"weight" : 1
}

var max_angle := Vector3(15, 180, 15)

var height_probe : RayCast
var points := []
	
	
func create_raycast_probe():
	height_probe = RayCast.new()
	add_child(height_probe)
	height_probe.enabled = true
	height_probe.global_transform.origin.y = 50
	height_probe.cast_to.y = -100


func _process(delta: float) -> void:
	if generate_world:
		generate()
		generate_world = false
		
	if extract_collisions:
		extract()
		extract_collisions = false
		
		
func extract():
	if get_child_count() > 0:
		var t = OS.get_ticks_msec()
		print("..:: starting ::..")
		var collision_shape_container := Spatial.new()
		get_parent().add_child(collision_shape_container)
		collision_shape_container.name = "ServerPropCollisions"
		collision_shape_container.set_owner(get_tree().edited_scene_root)
		for i in get_children():
			var new_collision_shape = find_node("StaticBody", true).duplicate(true)
			collision_shape_container.add_child(new_collision_shape)
			new_collision_shape.set_owner(get_tree().edited_scene_root)
			for x in new_collision_shape.get_children():
				x.set_owner(get_tree().edited_scene_root)
			new_collision_shape.transform = i.transform
		print("..:: CollisionShapes copied in %ss ::.." % ((OS.get_ticks_msec() - t) / 1000.0)) 
		
			
	
	
func clear():
	points = []
	
	for i in get_children():
		i.queue_free()
		
		
func generate():
	var t = OS.get_ticks_msec()
	print("..:: starting ::..")
	clear()
	create_raycast_probe()
	generate_points()
	place_meshes()
	print("..:: World Generated in %ss ::.." % ((OS.get_ticks_msec() - t) / 1000.0)) 
	
	
func generate_points():
	for i in range(0, density):
		points.append(Vector3(rand_range(-extents, extents), 0, rand_range(-extents, extents)))


func place_meshes():
	for point in points:
		var mesh_group := []
		for i in a["weight"]:
			for f in a["assets"]:
				mesh_group.append(f)
		for i in b["weight"]:
			for f in b["assets"]:
				mesh_group.append(f)
		for i in c["weight"]:
			for f in c["assets"]:
				mesh_group.append(f)
		
		height_probe.global_transform.origin.x = point.x
		height_probe.global_transform.origin.z = point.z
		height_probe.force_raycast_update()
		var target_pos : Vector3 = height_probe.get_collision_point()
#		if target_pos.y >= water_level:
		var random_mesh = mesh_group[randi() % mesh_group.size()]
		var new_mesh = random_mesh.instance()
		add_child(new_mesh)
		new_mesh.set_owner(get_tree().edited_scene_root)
		new_mesh.global_transform.origin += target_pos
		var rand_rot = Vector3(
				rand_range(-max_angle.x, max_angle.x),
				rand_range(-max_angle.y, max_angle.y),
				rand_range(-max_angle.z, max_angle.z)
		)
		new_mesh.rotation_degrees += rand_rot
