tool
extends StaticBody

export(bool) var generate := false

export(int) var max_altitude = 1

export(Image) var heightmap

export(float) var grass_max_slope = 0.55
export(float) var ground_max_slope = 0.6
export(float) var gravel_max_slope = 0.65

export(int) var rock_channel_scale = 1
export(Texture) var rock_channel_diffuse
export(Texture) var rock_channel_normal
export(Texture) var rock_channel_roughness
export(Texture) var rock_channel_ao

export(int) var gravel_channel_scale = 1
export(Texture) var gravel_channel_diffuse
export(Texture) var gravel_channel_normal
export(Texture) var gravel_channel_roughness
export(Texture) var gravel_channel_ao

export(int) var ground_channel_scale = 1
export(Texture) var ground_channel_diffuse
export(Texture) var ground_channel_normal
export(Texture) var ground_channel_roughness
export(Texture) var ground_channel_ao

export(int) var grass_channel_scale = 1
export(Texture) var grass_channel_diffuse
export(Texture) var grass_channel_normal
export(Texture) var grass_channel_roughness
export(Texture) var grass_channel_ao


var map_size : Vector2
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
	collision_shape.shape = HeightMapShape.new()
	collision_shape.shape.map_width = map_size.x
	collision_shape.shape.map_depth = map_size.y
	var float_array = PoolRealArray()
	heightmap.lock()
	for y in heightmap.get_height():
		for x in heightmap.get_width():
			float_array.append(heightmap.get_pixel(x, y).r * max_altitude)
	heightmap.unlock()
	collision_shape.shape.map_data = float_array


func configure_shader():
	terrain_shader.set_shader_param("max_altitude", max_altitude)
	
	terrain_shader.set_shader_param("heightmap", generate_heightmap_texture())
	terrain_shader.set_shader_param("normalmap", generate_normalmap_texture())
	
	terrain_shader.set_shader_param("ground_max_slope", ground_max_slope)
	terrain_shader.set_shader_param("gravel_max_slope", gravel_max_slope)
	terrain_shader.set_shader_param("grass_max_slope", grass_max_slope)

	terrain_shader.set_shader_param("rock_scale", rock_channel_scale)
	terrain_shader.set_shader_param("rock_diffuse", rock_channel_diffuse)
	terrain_shader.set_shader_param("rock_normal", rock_channel_normal)
	terrain_shader.set_shader_param("rock_roughness", rock_channel_roughness)
	terrain_shader.set_shader_param("rock_ao", rock_channel_ao)
	
	terrain_shader.set_shader_param("gravel_scale", gravel_channel_scale)
	terrain_shader.set_shader_param("gravel_diffuse", gravel_channel_diffuse)
	terrain_shader.set_shader_param("gravel_normal", gravel_channel_normal)
	terrain_shader.set_shader_param("gravel_roughness", gravel_channel_roughness)
	terrain_shader.set_shader_param("gravel_ao", gravel_channel_ao)
	
	terrain_shader.set_shader_param("ground_scale", ground_channel_scale)
	terrain_shader.set_shader_param("ground_diffuse", ground_channel_diffuse)
	terrain_shader.set_shader_param("ground_normal", ground_channel_normal)
	terrain_shader.set_shader_param("ground_roughness", ground_channel_roughness)
	terrain_shader.set_shader_param("ground_ao", ground_channel_ao)
	
	terrain_shader.set_shader_param("grass_scale", grass_channel_scale)
	terrain_shader.set_shader_param("grass_diffuse", grass_channel_diffuse)
	terrain_shader.set_shader_param("grass_normal", grass_channel_normal)
	terrain_shader.set_shader_param("grass_roughness", grass_channel_roughness)
	terrain_shader.set_shader_param("grass_ao", grass_channel_ao)


func process_images():
	map_size = Vector2(heightmap.get_width(), heightmap.get_height())


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
	mesh_instance.mesh.size = map_size
	mesh_instance.mesh.subdivide_width = map_size.x - 1
	mesh_instance.mesh.subdivide_depth = map_size.y - 1
	mesh_instance.mesh.set("material", terrain_shader)




