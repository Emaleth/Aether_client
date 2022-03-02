tool
extends Spatial
# GENERATE
export(bool) var generate_world := false
export(int, 0, 1000) var density = 0
export(int) var extents = 0


var a := {
	"assets" : [
		preload("res://source/environment/Bush.tscn"),
	],
	"weight" : 3
}

var b := {
	"assets" : [
		preload("res://source/environment/BlueTree.tscn"),
		preload("res://source/environment/RedTree.tscn"),
		preload("res://source/environment/YellowTree.tscn"),
		preload("res://source/environment/GreenTree.tscn"),
		preload("res://source/environment/PinkTree.tscn"),
	],
	"weight" : 5
}

var c := {
	"assets" : [
		preload("res://source/environment/Rock.tscn"),
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


func _process(_delta: float) -> void:
	if generate_world:
		generate()
		generate_world = false
			
	
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
	for _i in range(0, density):
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
