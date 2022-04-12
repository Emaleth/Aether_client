tool
extends StaticBody

export(bool) var generate := false

export var max_altitude := 1

export var heightmap : Image
export var splatmap : Texture

export var red_channel_scale := 1
export var red_channel_diffuse : Texture
export var red_channel_normal : Texture
export var red_channel_roughness : Texture
export var red_channel_ao : Texture

export var green_channel_scale := 1
export var green_channel_diffuse : Texture
export var green_channel_normal : Texture
export var green_channel_roughness : Texture
export var green_channel_ao : Texture

export var blue_channel_scale := 1
export var blue_channel_diffuse : Texture
export var blue_channel_normal : Texture
export var blue_channel_roughness : Texture
export var blue_channel_ao : Texture


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
	terrain_shader.set_shader_param("splatmap", splatmap)

	terrain_shader.set_shader_param("red_scale", red_channel_scale)
	terrain_shader.set_shader_param("red_diffuse", red_channel_diffuse)
	terrain_shader.set_shader_param("red_normal", red_channel_normal)
	terrain_shader.set_shader_param("red_roughness", red_channel_roughness)
	terrain_shader.set_shader_param("red_ao", red_channel_ao)

	terrain_shader.set_shader_param("green_scale", green_channel_scale)
	terrain_shader.set_shader_param("green_diffuse", green_channel_diffuse)
	terrain_shader.set_shader_param("green_normal", green_channel_normal)
	terrain_shader.set_shader_param("green_roughness", green_channel_roughness)
	terrain_shader.set_shader_param("green_ao", green_channel_ao)

	terrain_shader.set_shader_param("blue_scale", blue_channel_scale)
	terrain_shader.set_shader_param("blue_diffuse", blue_channel_diffuse)
	terrain_shader.set_shader_param("blue_normal", blue_channel_normal)
	terrain_shader.set_shader_param("blue_roughness", blue_channel_roughness)
	terrain_shader.set_shader_param("blue_ao", blue_channel_ao)


func process_images():
#	heightmap.convert(Image.FORMAT_RF)
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
