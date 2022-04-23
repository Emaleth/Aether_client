tool
extends StaticBody

export(bool) var generate := false
export(bool) var process_grass := false

export(int) var max_altitude = 1

export(Image) var heightmap : Image
export(Vector3) var terrain_scale = Vector3(1, 1, 1)

export(float) var steepness = 0.5
export(float) var culling_max_distance = 100.0
export(float) var grass_render_distance = 100
export(float) var triplanar_scale = 1.0
export(float) var ab0_half_blend_amount = 0.05
export(float) var ab1_half_blend_amount = 0.05
export(float) var steepness_half_blend_amount = 0.05
export(float) var grass_density = 1

export(Texture) var antitile_noise
export(Texture) var ab0_noise
export(Texture) var ab1_noise

export(Vector2) var texture0a_scale = Vector2(1, 1)
export(Texture) var texture0a_diffuse
export(Texture) var texture0a_normal
export(Texture) var texture0a_roughness
export(Texture) var texture0a_ao

export(Vector2) var texture0b_scale = Vector2(1, 1)
export(Texture) var texture0b_diffuse
export(Texture) var texture0b_normal
export(Texture) var texture0b_roughness
export(Texture) var texture0b_ao

export(Vector2) var texture1a_scale = Vector2(1, 1)
export(Texture) var texture1a_diffuse
export(Texture) var texture1a_normal
export(Texture) var texture1a_roughness
export(Texture) var texture1a_ao

export(Vector2) var texture1b_scale = Vector2(1, 1)
export(Texture) var texture1b_diffuse
export(Texture) var texture1b_normal
export(Texture) var texture1b_roughness
export(Texture) var texture1b_ao

var heightmap_size : Vector2
var collision_shape : CollisionShape
var mesh_instance : MeshInstance
var terrain_shader : Resource
var grass_mesh : Resource
var multi_mesh_instance : MultiMeshInstance



func _process(_delta: float) -> void:
	if generate:
		initialize()
		configure_shader()
		process_images()
		configure_mesh()
		generate_collision_shape()
		initialize_multi_mesh_instance()
		generate = false
		
	if process_grass:
		process_grass()


func initialize():
	collision_shape = $CollisionShape
	mesh_instance = $MeshInstance
	multi_mesh_instance = $MultiMeshInstance
	terrain_shader = preload("res://resources/materials/terrain.tres")
	grass_mesh = preload("res://new_quadmesh.tres")


func generate_collision_shape():
	heightmap.convert(Image.FORMAT_RGBAF)
	collision_shape.shape = HeightMapShape.new()
	collision_shape.shape.map_width = heightmap_size.x
	collision_shape.shape.map_depth = heightmap_size.y
	var float_array = PoolRealArray()
	heightmap.lock()
	for y in heightmap.get_height():
		for x in heightmap.get_width():
			float_array.append(heightmap.get_pixel(x, y).r * max_altitude)
	heightmap.unlock()
	collision_shape.shape.map_data = float_array
	collision_shape.scale = terrain_scale


func configure_shader():
	terrain_shader.set_shader_param("max_altitude", max_altitude * terrain_scale.y)
	
	terrain_shader.set_shader_param("heightmap", generate_heightmap_texture())
	terrain_shader.set_shader_param("normalmap", generate_normalmap_texture())
	
	terrain_shader.set_shader_param("steepness", steepness)
	terrain_shader.set_shader_param("triplanar_scale", triplanar_scale)
	terrain_shader.set_shader_param("culling_max_distance", culling_max_distance)

	terrain_shader.set_shader_param("texture0a_scale", texture0a_scale)
	terrain_shader.set_shader_param("texture0a_diffuse", texture0a_diffuse)
	terrain_shader.set_shader_param("texture0a_normal", texture0a_normal)
	terrain_shader.set_shader_param("texture0a_roughness", texture0a_roughness)
	terrain_shader.set_shader_param("texture0a_ao", texture0a_ao)
	
	terrain_shader.set_shader_param("texture0b_scale", texture0b_scale)
	terrain_shader.set_shader_param("texture0b_diffuse", texture0b_diffuse)
	terrain_shader.set_shader_param("texture0b_normal", texture0b_normal)
	terrain_shader.set_shader_param("texture0b_roughness", texture0b_roughness)
	terrain_shader.set_shader_param("texture0b_ao", texture0b_ao)
	
	terrain_shader.set_shader_param("texture1a_scale", texture1a_scale)
	terrain_shader.set_shader_param("texture1a_diffuse", texture1a_diffuse)
	terrain_shader.set_shader_param("texture1a_normal", texture1a_normal)
	terrain_shader.set_shader_param("texture1a_roughness", texture1a_roughness)
	terrain_shader.set_shader_param("texture1a_ao", texture1a_ao)
	
	terrain_shader.set_shader_param("texture1b_scale", texture1b_scale)
	terrain_shader.set_shader_param("texture1b_diffuse", texture1b_diffuse)
	terrain_shader.set_shader_param("texture1b_normal", texture1b_normal)
	terrain_shader.set_shader_param("texture1b_roughness", texture1b_roughness)
	terrain_shader.set_shader_param("texture1b_ao", texture1b_ao)
	
	terrain_shader.set_shader_param("antitile_noise", antitile_noise)
	terrain_shader.set_shader_param("ab0_noise", ab0_noise)
	terrain_shader.set_shader_param("ab1_noise", ab1_noise)

	terrain_shader.set_shader_param("ab0_half_blend_amount", ab0_half_blend_amount)
	terrain_shader.set_shader_param("ab1_half_blend_amount", ab1_half_blend_amount)
	terrain_shader.set_shader_param("steepness_half_blend_amount", steepness_half_blend_amount)


func process_images():
	heightmap_size = Vector2(heightmap.get_width(), heightmap.get_height())


func generate_heightmap_texture() -> ImageTexture:
	var texture := ImageTexture.new()
	texture.create_from_image(heightmap)
	return texture

var nrm
func generate_normalmap_texture() -> ImageTexture:
	var texture := ImageTexture.new()
	var tmp_image : Image = heightmap.duplicate(true)
	tmp_image.bumpmap_to_normalmap(max_altitude)
	nrm = tmp_image.duplicate(true)
	texture.create_from_image(tmp_image)
	return texture


func configure_mesh():
	mesh_instance.mesh = PlaneMesh.new()
	mesh_instance.mesh.size = heightmap_size
	mesh_instance.mesh.subdivide_width = heightmap_size.x - 1
	mesh_instance.mesh.subdivide_depth = heightmap_size.y - 1
	mesh_instance.mesh.set("material", terrain_shader)
	mesh_instance.scale.x = terrain_scale.x
	mesh_instance.scale.z = terrain_scale.z
	
	
var final_grass_array := []
var blades_array := []
func initialize_multi_mesh_instance():
	var grass_position_array := []
	var grass_normal_array := []
	final_grass_array = []
	blades_array = []
	
	multi_mesh_instance.multimesh = MultiMesh.new()
	multi_mesh_instance.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multi_mesh_instance.multimesh.color_format = MultiMesh.COLOR_NONE
	multi_mesh_instance.multimesh.custom_data_format = MultiMesh.CUSTOM_DATA_NONE
	multi_mesh_instance.multimesh.mesh = grass_mesh
	
	heightmap.lock()
	for y in heightmap.get_height():
		for x in heightmap.get_width():
			grass_position_array.append(Vector3(x - heightmap_size.x / 2, heightmap.get_pixel(x, y).r * max_altitude, y - heightmap_size.y / 2))
	heightmap.unlock()

	nrm.lock()
	for y in nrm.get_height():
		for x in nrm.get_width():
			grass_normal_array.append(Vector3(nrm.get_pixel(x, y).r, nrm.get_pixel(x, y).g, nrm.get_pixel(x, y).b))
	nrm.unlock()

	for i in grass_position_array.size():
		if acos(grass_normal_array[i].z) < steepness:
			var blades := []
			for n in range(grass_density):
				blades.append(Transform(
					Basis(),
					Vector3(
						rand_range(grass_position_array[i].x - 0.55, grass_position_array[i].x + 0.55), 
						rand_range(grass_position_array[i].y - 0.1, grass_position_array[i].y + 0.1), 
						rand_range(grass_position_array[i].z - 0.55, grass_position_array[i].z + 0.55)
						)
					))
			final_grass_array.append([grass_position_array[i], blades])
				
				
func process_grass():
	var peg = $Position3D
	var valid_positions := []
	
	for i in final_grass_array.size():
		if final_grass_array[i][0].distance_squared_to(peg.global_transform.origin) < pow(grass_render_distance, 2):
			valid_positions.append_array(final_grass_array[i][1])
		
	multi_mesh_instance.multimesh.instance_count = valid_positions.size()
	
	for i in multi_mesh_instance.multimesh.instance_count:
		multi_mesh_instance.multimesh.set_instance_transform(i, valid_positions[i])
