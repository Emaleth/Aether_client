tool
extends StaticBody

export(bool) var generate := false

export(int) var max_altitude = 1

export(Image) var heightmap
export(Texture) var normalmap

export(Texture) var splatmap_0
#export(Texture) var splatmap_1
#export(Texture) var splatmap_2
#export(Texture) var splatmap_3

export(int) var red_0_channel_scale = 1
export(Texture) var red_0_channel_diffuse
export(Texture) var red_0_channel_normal
export(Texture) var red_0_channel_roughness
export(Texture) var red_0_channel_ao

export var green_0_channel_scale := 1
export var green_0_channel_diffuse : Texture
export var green_0_channel_normal : Texture
export var green_0_channel_roughness : Texture
export var green_0_channel_ao : Texture

export var blue_0_channel_scale := 1
export var blue_0_channel_diffuse : Texture
export var blue_0_channel_normal : Texture
export var blue_0_channel_roughness : Texture
export var blue_0_channel_ao : Texture

export var alpha_0_channel_scale := 1
export var alpha_0_channel_diffuse : Texture
export var alpha_0_channel_normal : Texture
export var alpha_0_channel_roughness : Texture
export var alpha_0_channel_ao : Texture

#
#export var red_1_channel_scale := 1
#export var red_1_channel_diffuse : Texture
#export var red_1_channel_normal : Texture
#export var red_1_channel_roughness : Texture
#export var red_1_channel_ao : Texture
#
#export var green_1_channel_scale := 1
#export var green_1_channel_diffuse : Texture
#export var green_1_channel_normal : Texture
#export var green_1_channel_roughness : Texture
#export var green_1_channel_ao : Texture
#
#export var blue_1_channel_scale := 1
#export var blue_1_channel_diffuse : Texture
#export var blue_1_channel_normal : Texture
#export var blue_1_channel_roughness : Texture
#export var blue_1_channel_ao : Texture
#
#export var alpha_1_channel_scale := 1
#export var alpha_1_channel_diffuse : Texture
#export var alpha_1_channel_normal : Texture
#export var alpha_1_channel_roughness : Texture
#export var alpha_1_channel_ao : Texture
#
#
#export var red_2_channel_scale := 1
#export var red_2_channel_diffuse : Texture
#export var red_2_channel_normal : Texture
#export var red_2_channel_roughness : Texture
#export var red_2_channel_ao : Texture
#
#export var green_2_channel_scale := 1
#export var green_2_channel_diffuse : Texture
#export var green_2_channel_normal : Texture
#export var green_2_channel_roughness : Texture
#export var green_2_channel_ao : Texture
#
#export var blue_2_channel_scale := 1
#export var blue_2_channel_diffuse : Texture
#export var blue_2_channel_normal : Texture
#export var blue_2_channel_roughness : Texture
#export var blue_2_channel_ao : Texture
#
#export var alpha_2_channel_scale := 1
#export var alpha_2_channel_diffuse : Texture
#export var alpha_2_channel_normal : Texture
#export var alpha_2_channel_roughness : Texture
#export var alpha_2_channel_ao : Texture
#
#
#export var red_3_channel_scale := 1
#export var red_3_channel_diffuse : Texture
#export var red_3_channel_normal : Texture
#export var red_3_channel_roughness : Texture
#export var red_3_channel_ao : Texture
#
#export var green_3_channel_scale := 1
#export var green_3_channel_diffuse : Texture
#export var green_3_channel_normal : Texture
#export var green_3_channel_roughness : Texture
#export var green_3_channel_ao : Texture
#
#export var blue_3_channel_scale := 1
#export var blue_3_channel_diffuse : Texture
#export var blue_3_channel_normal : Texture
#export var blue_3_channel_roughness : Texture
#export var blue_3_channel_ao : Texture
#
#export var alpha_3_channel_scale := 1
#export var alpha_3_channel_diffuse : Texture
#export var alpha_3_channel_normal : Texture
#export var alpha_3_channel_roughness : Texture
#export var alpha_3_channel_ao : Texture

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
	if splatmap_0:
		terrain_shader.set_shader_param("splatmap_0_enabled", true)
		terrain_shader.set_shader_param("splatmap_0", splatmap_0)
#	if splatmap_1:
#		terrain_shader.set_shader_param("splatmap_1_enabled", true)
#		terrain_shader.set_shader_param("splatmap_1", splatmap_1)
#	if splatmap_2:
#		terrain_shader.set_shader_param("splatmap_2_enabled", true)
#		terrain_shader.set_shader_param("splatmap_2", splatmap_2)
#	if splatmap_3:
#		terrain_shader.set_shader_param("splatmap_3_enabled", true)
#		terrain_shader.set_shader_param("splatmap_3", splatmap_3)

	if red_0_channel_diffuse:
		terrain_shader.set_shader_param("red_0_enabled", true)
	else:
		terrain_shader.set_shader_param("red_0_enabled", false)
	terrain_shader.set_shader_param("red_0_scale", red_0_channel_scale)
	terrain_shader.set_shader_param("red_0_diffuse", red_0_channel_diffuse)
	terrain_shader.set_shader_param("red_0_normal", red_0_channel_normal)
	terrain_shader.set_shader_param("red_0_roughness", red_0_channel_roughness)
	terrain_shader.set_shader_param("red_0_ao", red_0_channel_ao)

	if green_0_channel_diffuse:
		terrain_shader.set_shader_param("green_0_enabled", true)
	else:
		terrain_shader.set_shader_param("green_0_enabled", false)
	terrain_shader.set_shader_param("green_0_scale", green_0_channel_scale)
	terrain_shader.set_shader_param("green_0_diffuse", green_0_channel_diffuse)
	terrain_shader.set_shader_param("green_0_normal", green_0_channel_normal)
	terrain_shader.set_shader_param("green_0_roughness", green_0_channel_roughness)
	terrain_shader.set_shader_param("green_0_ao", green_0_channel_ao)

	if blue_0_channel_diffuse:
		terrain_shader.set_shader_param("blue_0_enabled", true)
	else:
		terrain_shader.set_shader_param("blue_0_enabled", false)
	terrain_shader.set_shader_param("blue_0_scale", blue_0_channel_scale)
	terrain_shader.set_shader_param("blue_0_diffuse", blue_0_channel_diffuse)
	terrain_shader.set_shader_param("blue_0_normal", blue_0_channel_normal)
	terrain_shader.set_shader_param("blue_0_roughness", blue_0_channel_roughness)
	terrain_shader.set_shader_param("blue_0_ao", blue_0_channel_ao)

	if alpha_0_channel_diffuse:
		terrain_shader.set_shader_param("alpha_0_enabled", true)
	else:
		terrain_shader.set_shader_param("alpha_0_enabled", false)
	terrain_shader.set_shader_param("alpha_0_scale", alpha_0_channel_scale)
	terrain_shader.set_shader_param("alpha_0_diffuse", alpha_0_channel_diffuse)
	terrain_shader.set_shader_param("alpha_0_normal", alpha_0_channel_normal)
	terrain_shader.set_shader_param("alpha_0_roughness", alpha_0_channel_roughness)
	terrain_shader.set_shader_param("alpha_0_ao", alpha_0_channel_ao)

#	terrain_shader.set_shader_param("red_1_scale", red_1_channel_scale)
#	terrain_shader.set_shader_param("red_1_diffuse", red_1_channel_diffuse)
#	terrain_shader.set_shader_param("red_1_normal", red_1_channel_normal)
#	terrain_shader.set_shader_param("red_1_roughness", red_1_channel_roughness)
#	terrain_shader.set_shader_param("red_1_ao", red_1_channel_ao)
#
#	terrain_shader.set_shader_param("green_1_scale", green_1_channel_scale)
#	terrain_shader.set_shader_param("green_1_diffuse", green_1_channel_diffuse)
#	terrain_shader.set_shader_param("green_1_normal", green_1_channel_normal)
#	terrain_shader.set_shader_param("green_1_roughness", green_1_channel_roughness)
#	terrain_shader.set_shader_param("green_1_ao", green_1_channel_ao)
#
#	terrain_shader.set_shader_param("blue_1_scale", blue_1_channel_scale)
#	terrain_shader.set_shader_param("blue_1_diffuse", blue_1_channel_diffuse)
#	terrain_shader.set_shader_param("blue_1_normal", blue_1_channel_normal)
#	terrain_shader.set_shader_param("blue_1_roughness", blue_1_channel_roughness)
#	terrain_shader.set_shader_param("blue_1_ao", blue_1_channel_ao)
#
#	terrain_shader.set_shader_param("alpha_1_scale", alpha_1_channel_scale)
#	terrain_shader.set_shader_param("alpha_1_diffuse", alpha_1_channel_diffuse)
#	terrain_shader.set_shader_param("alpha_1_normal", alpha_1_channel_normal)
#	terrain_shader.set_shader_param("alpha_1_roughness", alpha_1_channel_roughness)
#	terrain_shader.set_shader_param("alpha_1_ao", alpha_1_channel_ao)
#
#	terrain_shader.set_shader_param("red_2_scale", red_2_channel_scale)
#	terrain_shader.set_shader_param("red_2_diffuse", red_2_channel_diffuse)
#	terrain_shader.set_shader_param("red_2_normal", red_2_channel_normal)
#	terrain_shader.set_shader_param("red_2_roughness", red_2_channel_roughness)
#	terrain_shader.set_shader_param("red_2_ao", red_2_channel_ao)
#
#	terrain_shader.set_shader_param("green_2_scale", green_2_channel_scale)
#	terrain_shader.set_shader_param("green_2_diffuse", green_2_channel_diffuse)
#	terrain_shader.set_shader_param("green_2_normal", green_2_channel_normal)
#	terrain_shader.set_shader_param("green_2_roughness", green_2_channel_roughness)
#	terrain_shader.set_shader_param("green_2_ao", green_2_channel_ao)
#
#	terrain_shader.set_shader_param("blue_2_scale", blue_2_channel_scale)
#	terrain_shader.set_shader_param("blue_2_diffuse", blue_2_channel_diffuse)
#	terrain_shader.set_shader_param("blue_2_normal", blue_2_channel_normal)
#	terrain_shader.set_shader_param("blue_2_roughness", blue_2_channel_roughness)
#	terrain_shader.set_shader_param("blue_2_ao", blue_2_channel_ao)
#
#	terrain_shader.set_shader_param("alpha_2_scale", alpha_2_channel_scale)
#	terrain_shader.set_shader_param("alpha_2_diffuse", alpha_2_channel_diffuse)
#	terrain_shader.set_shader_param("alpha_2_normal", alpha_2_channel_normal)
#	terrain_shader.set_shader_param("alpha_2_roughness", alpha_2_channel_roughness)
#	terrain_shader.set_shader_param("alpha_2_ao", alpha_2_channel_ao)
#
#	terrain_shader.set_shader_param("red_3_scale", red_3_channel_scale)
#	terrain_shader.set_shader_param("red_3_diffuse", red_3_channel_diffuse)
#	terrain_shader.set_shader_param("red_3_normal", red_3_channel_normal)
#	terrain_shader.set_shader_param("red_3_roughness", red_3_channel_roughness)
#	terrain_shader.set_shader_param("red_3_ao", red_3_channel_ao)
#
#	terrain_shader.set_shader_param("green_3_scale", green_3_channel_scale)
#	terrain_shader.set_shader_param("green_3_diffuse", green_3_channel_diffuse)
#	terrain_shader.set_shader_param("green_3_normal", green_3_channel_normal)
#	terrain_shader.set_shader_param("green_3_roughness", green_3_channel_roughness)
#	terrain_shader.set_shader_param("green_3_ao", green_3_channel_ao)
#
#	terrain_shader.set_shader_param("blue_3_scale", blue_3_channel_scale)
#	terrain_shader.set_shader_param("blue_3_diffuse", blue_3_channel_diffuse)
#	terrain_shader.set_shader_param("blue_3_normal", blue_3_channel_normal)
#	terrain_shader.set_shader_param("blue_3_roughness", blue_3_channel_roughness)
#	terrain_shader.set_shader_param("blue_3_ao", blue_3_channel_ao)
#
#	terrain_shader.set_shader_param("alpha_3_scale", alpha_3_channel_scale)
#	terrain_shader.set_shader_param("alpha_3_diffuse", alpha_3_channel_diffuse)
#	terrain_shader.set_shader_param("alpha_3_normal", alpha_3_channel_normal)
#	terrain_shader.set_shader_param("alpha_3_roughness", alpha_3_channel_roughness)
#	terrain_shader.set_shader_param("alpha_3_ao", alpha_3_channel_ao)


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
