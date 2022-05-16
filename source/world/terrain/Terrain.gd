tool
extends StaticBody

export(bool) var generate := false
export(bool) var enable_grass_processing := false

export(int) var max_altitude = 1

export(Image) var heightmap_image : Image = null
export(Image) var normalmap_image : Image = null
export(Texture) var splatmap : Texture = null

export(Vector3) var terrain_scale = Vector3(1, 1, 1)

export(float) var steepness = 0.7
export(int) var culling_max_distance = 100
export(int) var grass_render_distance = 5
export(int) var triplanar_scale = 1
export(float) var steepness_blend_amount = 0.05

export(Texture) var antitile_noise

export(Vector2) var texture_flat_scale = Vector2(1, 1)
export(Texture) var texture_flat_diffuse
export(Texture) var texture_flat_normal
export(Texture) var texture_flat_roughness
export(Texture) var texture_flat_ao

export(Vector2) var texture_slope_scale = Vector2(1, 1)
export(Texture) var texture_slope_diffuse
export(Texture) var texture_slope_normal
export(Texture) var texture_slope_roughness
export(Texture) var texture_slope_ao

export(Vector2) var texture_red_scale = Vector2(1, 1)
export(Texture) var texture_red_diffuse
export(Texture) var texture_red_normal
export(Texture) var texture_red_roughness
export(Texture) var texture_red_ao

export(Vector2) var texture_green_scale = Vector2(1, 1)
export(Texture) var texture_green_diffuse
export(Texture) var texture_green_normal
export(Texture) var texture_green_roughness
export(Texture) var texture_green_ao

export(Vector2) var texture_blue_scale = Vector2(1, 1)
export(Texture) var texture_blue_diffuse
export(Texture) var texture_blue_normal
export(Texture) var texture_blue_roughness
export(Texture) var texture_blue_ao

export(Material) var terrain_shader : Material
export(Material) var grass_shader : Material
export(Mesh) var grass_mesh : Mesh

var collision_shape : CollisionShape
var mesh_instance : MeshInstance
var multi_mesh_instance : MultiMeshInstance

var grass_array := []


#func _ready() -> void:
#	generate = true


func _process(_delta: float) -> void:
	if generate:
		var t = OS.get_ticks_msec()
		print("..:: starting ::..")
		initialize()
		generate_normalmap_image()
		configure_shader()
		configure_terrain_mesh()
		configure_grass_mesh()
		generate_collision_shape()
		initialize_multi_mesh_instance()
		print("..:: World Generated in %ss ::.." % ((OS.get_ticks_msec() - t) / 1000.0)) 
		generate = false

	if enable_grass_processing:
		process_grass()


func initialize():
	collision_shape = $CollisionShape
	mesh_instance = $MeshInstance
	multi_mesh_instance = $MultiMeshInstance
	height_probe = $RayCast


func generate_collision_shape():
	collision_shape.shape = HeightMapShape.new()
	collision_shape.shape.map_width = heightmap_image.get_width()
	collision_shape.shape.map_depth = heightmap_image.get_height()
	collision_shape.shape.map_data = sample_image_y_r(heightmap_image, max_altitude)
	collision_shape.scale = terrain_scale
	
	var navmesh : NavigationMesh = NavigationMesh.new()
	var vertices : PoolVector3Array = sample_image_xyz_r(heightmap_image, max_altitude)
	var indices : PoolIntArray
	for i in vertices.size() : indices.append(i) 
	navmesh.vertices = vertices
	navmesh.add_polygon(indices)
	$NavigationMeshInstance.navmesh = navmesh


func configure_shader():
	terrain_shader.set_shader_param("max_altitude", max_altitude * terrain_scale.y)

	terrain_shader.set_shader_param("heightmap", generate_heightmap_texture())
	terrain_shader.set_shader_param("normalmap", generate_normalmap_texture())
	terrain_shader.set_shader_param("splatmap", splatmap)

	terrain_shader.set_shader_param("steepness", steepness)
	terrain_shader.set_shader_param("triplanar_scale", triplanar_scale)
	terrain_shader.set_shader_param("culling_max_distance", culling_max_distance)

	terrain_shader.set_shader_param("texture_flat_scale", texture_flat_scale)
	terrain_shader.set_shader_param("texture_flat_diffuse", texture_flat_diffuse)
	terrain_shader.set_shader_param("texture_flat_normal", texture_flat_normal)
	terrain_shader.set_shader_param("texture_flat_roughness", texture_flat_roughness)
	terrain_shader.set_shader_param("texture_flat_ao", texture_flat_ao)

	terrain_shader.set_shader_param("texture_slope_scale", texture_slope_scale)
	terrain_shader.set_shader_param("texture_slope_diffuse", texture_slope_diffuse)
	terrain_shader.set_shader_param("texture_slope_normal", texture_slope_normal)
	terrain_shader.set_shader_param("texture_slope_roughness", texture_slope_roughness)
	terrain_shader.set_shader_param("texture_slope_ao", texture_slope_ao)

	terrain_shader.set_shader_param("texture_red_scale", texture_red_scale)
	terrain_shader.set_shader_param("texture_red_diffuse", texture_red_diffuse)
	terrain_shader.set_shader_param("texture_red_normal", texture_red_normal)
	terrain_shader.set_shader_param("texture_red_roughness", texture_red_roughness)
	terrain_shader.set_shader_param("texture_red_ao", texture_red_ao)
	
	terrain_shader.set_shader_param("texture_green_scale", texture_green_scale)
	terrain_shader.set_shader_param("texture_green_diffuse", texture_green_diffuse)
	terrain_shader.set_shader_param("texture_green_normal", texture_green_normal)
	terrain_shader.set_shader_param("texture_green_roughness", texture_green_roughness)
	terrain_shader.set_shader_param("texture_green_ao", texture_green_ao)
	
	terrain_shader.set_shader_param("texture_blue_scale", texture_blue_scale)
	terrain_shader.set_shader_param("texture_blue_diffuse", texture_blue_diffuse)
	terrain_shader.set_shader_param("texture_blue_normal", texture_blue_normal)
	terrain_shader.set_shader_param("texture_blue_roughness", texture_blue_roughness)
	terrain_shader.set_shader_param("texture_blue_ao", texture_blue_ao)
	
	terrain_shader.set_shader_param("antitile_noise", antitile_noise)

	terrain_shader.set_shader_param("steepness_blend_amount", steepness_blend_amount)


func generate_normalmap_image():
	if normalmap_image:
		return
	normalmap_image = heightmap_image.duplicate(true)
	normalmap_image.bumpmap_to_normalmap(max_altitude)


func generate_heightmap_texture() -> ImageTexture:
	var texture := ImageTexture.new()
	texture.create_from_image(heightmap_image, 0)
	return texture


func generate_normalmap_texture() -> ImageTexture:
	var texture := ImageTexture.new()
	texture.create_from_image(normalmap_image, 4)
	return texture


func sample_image_y_r(image : Image, offset : int) -> PoolRealArray:
	image.convert(Image.FORMAT_RGBAF)
	var result : PoolRealArray = []
	image.lock()
	for y in image.get_height():
		for x in image.get_width():
			result.append(image.get_pixel(x, y).r * offset)
	image.unlock()
	return result


func sample_image_xyz_r(image : Image, offset : int) -> PoolVector3Array:
	image.convert(Image.FORMAT_RGBAF)
	var result : PoolVector3Array = []
	image.lock()
	for y in image.get_height():
		for x in image.get_width():
			result.append(Vector3(x - image.get_height()/2, image.get_pixel(x, y).r * offset, y - image.get_width()/2))
	image.unlock()
	return result
	

func configure_terrain_mesh():
	mesh_instance.mesh = PlaneMesh.new()
	mesh_instance.mesh.size = heightmap_image.get_size() - Vector2(1, 1)
	mesh_instance.mesh.subdivide_width = heightmap_image.get_width() - 2
	mesh_instance.mesh.subdivide_depth = heightmap_image.get_height() - 2
	mesh_instance.mesh.set("material", terrain_shader)
	mesh_instance.scale.x = terrain_scale.x
	mesh_instance.scale.z = terrain_scale.z
	
	
func configure_grass_mesh():
	for i in grass_mesh.get_surface_count():
		grass_mesh.surface_set_material(i, grass_shader)


func initialize_multi_mesh_instance():
	grass_array = []
	multi_mesh_instance.multimesh = MultiMesh.new()
	multi_mesh_instance.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multi_mesh_instance.multimesh.color_format = MultiMesh.COLOR_NONE
	multi_mesh_instance.multimesh.custom_data_format = MultiMesh.CUSTOM_DATA_NONE
	multi_mesh_instance.multimesh.mesh = grass_mesh
	grass_array = get_point_normal()


func process_grass():
	var peg = $Position3D
	var valid_positions := []
	for i in grass_array.size():
		if grass_array[i][1].distance_squared_to(peg.global_transform.origin) < pow(grass_render_distance, 2):
			if acos(grass_array[i][0].y) < steepness-0.1:
				valid_positions.append(look_at_with_y(
					Transform(Basis(), grass_array[i][1]),
					grass_array[i][0],
					grass_array[i][1].cross(grass_array[i][1] + grass_array[i][0])))
	multi_mesh_instance.multimesh.instance_count = valid_positions.size()
	for i in multi_mesh_instance.multimesh.instance_count:
		multi_mesh_instance.multimesh.set_instance_transform(i, valid_positions[i])
	
	
var height_probe : RayCast
	
	
func get_point_normal():
	var points : Array
	for x in range(-heightmap_image.get_width()/2, heightmap_image.get_width()/2):
		for y in range(-heightmap_image.get_height()/2, heightmap_image.get_height()/2):
			height_probe.global_transform.origin = Vector3(x, 500, y)
#			yield(get_tree(),"idle_frame")
			height_probe.force_raycast_update()
			points.append([height_probe.get_collision_normal(), height_probe.get_collision_point()])
	return points


func look_at_with_y(trans,new_y,v_up):
	#Y vector
	trans.basis.y=new_y.normalized()
	trans.basis.z=v_up*-1
	trans.basis.x = trans.basis.z.cross(trans.basis.y).normalized();
	#Recompute z = y cross X
	trans.basis.z = trans.basis.y.cross(trans.basis.x).normalized();
	trans.basis.x = trans.basis.x * -1   # <======= ADDED THIS LINE
	trans.basis = trans.basis.orthonormalized() # make sure it is valid 
	return trans
