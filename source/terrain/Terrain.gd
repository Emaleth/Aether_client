tool
extends StaticBody

export(bool) var generate := false

export(int) var max_altitude = 1

export(Image) var heightmap
export(Vector3) var terrain_scale = Vector3(1, 1, 1)

export(float) var steepness = 0.55

export(Texture) var ab_noise
export(Texture) var antitile_noise

export(Vector2) var texture0a_channel_scale = Vector2(1, 1)
export(Texture) var texture0a_channel_diffuse
export(Texture) var texture0a_channel_normal
export(Texture) var texture0a_channel_roughness
export(Texture) var texture0a_channel_ao

export(Vector2) var texture0b_channel_scale = Vector2(1, 1)
export(Texture) var texture0b_channel_diffuse
export(Texture) var texture0b_channel_normal
export(Texture) var texture0b_channel_roughness
export(Texture) var texture0b_channel_ao

export(Vector2) var texture1a_channel_scale = Vector2(1, 1)
export(Texture) var texture1a_channel_diffuse
export(Texture) var texture1a_channel_normal
export(Texture) var texture1a_channel_roughness
export(Texture) var texture1a_channel_ao

export(Vector2) var texture1b_channel_scale = Vector2(1, 1)
export(Texture) var texture1b_channel_diffuse
export(Texture) var texture1b_channel_normal
export(Texture) var texture1b_channel_roughness
export(Texture) var texture1b_channel_ao



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
	heightmap.convert(Image.FORMAT_RF)
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
	terrain_shader.set_shader_param("max_altitude", max_altitude)
	
	terrain_shader.set_shader_param("heightmap", generate_heightmap_texture())
	terrain_shader.set_shader_param("normalmap", generate_normalmap_texture())
	
	terrain_shader.set_shader_param("steepness", steepness)

	terrain_shader.set_shader_param("texture0a_scale", texture0a_channel_scale)
	terrain_shader.set_shader_param("texture0a_diffuse", texture0a_channel_diffuse)
	terrain_shader.set_shader_param("texture0a_normal", texture0a_channel_normal)
	terrain_shader.set_shader_param("texture0a_roughness", texture0a_channel_roughness)
	terrain_shader.set_shader_param("texture0a_ao", texture0a_channel_ao)
	
	terrain_shader.set_shader_param("texture0b_scale", texture0b_channel_scale)
	terrain_shader.set_shader_param("texture0b_diffuse", texture0b_channel_diffuse)
	terrain_shader.set_shader_param("texture0b_normal", texture0b_channel_normal)
	terrain_shader.set_shader_param("texture0b_roughness", texture0b_channel_roughness)
	terrain_shader.set_shader_param("texture0b_ao", texture0b_channel_ao)
	
	terrain_shader.set_shader_param("texture1a_scale", texture1a_channel_scale)
	terrain_shader.set_shader_param("texture1a_diffuse", texture1a_channel_diffuse)
	terrain_shader.set_shader_param("texture1a_normal", texture1a_channel_normal)
	terrain_shader.set_shader_param("texture1a_roughness", texture1a_channel_roughness)
	terrain_shader.set_shader_param("texture1a_ao", texture1a_channel_ao)
	
	terrain_shader.set_shader_param("texture1b_scale", texture1b_channel_scale)
	terrain_shader.set_shader_param("texture1b_diffuse", texture1b_channel_diffuse)
	terrain_shader.set_shader_param("texture1b_normal", texture1b_channel_normal)
	terrain_shader.set_shader_param("texture1b_roughness", texture1b_channel_roughness)
	terrain_shader.set_shader_param("texture1b_ao", texture1b_channel_ao)
	
	terrain_shader.set_shader_param("antitile_noise", antitile_noise)
	terrain_shader.set_shader_param("ab_noise", ab_noise)


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
	mesh_instance.scale = terrain_scale




