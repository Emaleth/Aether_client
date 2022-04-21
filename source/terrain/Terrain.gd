tool
extends StaticBody

export(bool) var generate := false

export(int) var max_altitude = 1

export(Image) var heightmap : Image
export(Vector3) var terrain_scale = Vector3(1, 1, 1)

export(float) var steepness = 0.5
export(float) var culling_max_distance = 100.0
export(float) var triplanar_scale = 1.0
export(float) var ab0_half_blend_amount = 0.05
export(float) var ab1_half_blend_amount = 0.05
export(float) var steepness_half_blend_amount = 0.05

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


func _process(delta: float) -> void:
	if generate:
		initialize()
		configure_shader()
		process_images()
		configure_mesh()
		generate_collision_shape()
		generate = false


func initialize():
	collision_shape = $CollisionShape
	mesh_instance = $MeshInstance
	terrain_shader = preload("res://resources/materials/terrain.tres")


func generate_collision_shape():
#	if heightmap.get_format() != Image.FORMAT_RF:
#		heightmap.convert(Image.FORMAT_RF)
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


func generate_normalmap_texture() -> ImageTexture:
	var texture := ImageTexture.new()
	var tmp_image : Image = heightmap.duplicate(true)
	tmp_image.bumpmap_to_normalmap(max_altitude)
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




