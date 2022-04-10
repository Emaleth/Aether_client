#tool
extends StaticBody


export var height : int
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


var size = Vector2.ZERO
var h_map_img : Image
var h_map_tex := ImageTexture.new()
var n_map_tex := ImageTexture.new()
var s_map_tex := ImageTexture.new()
	
onready var collision_shape := $CollisionShape
onready var mesh_instance := $MeshInstance
onready var terrain_shader := preload("res://resources/materials/terrain.tres")


func _ready() -> void:
	process_images()
	configure_mesh()
	configure_shader()
	generate_collision_shape()
		
			
func generate_collision_shape():
	collision_shape.shape = HeightMapShape.new()
	collision_shape.shape.map_width = size.x
	collision_shape.shape.map_depth = size.y
	var float_array = PoolRealArray()
	h_map_img.lock()
	for y in h_map_img.get_height():
		for x in h_map_img.get_width():
			float_array.append(h_map_img.get_pixel(x, y).r * height)
	h_map_img.unlock()
	collision_shape.shape.map_data = float_array


func configure_shader():
	mesh_instance.mesh.material.set("shader_param/heightmap", h_map_tex)
	mesh_instance.mesh.material.set("shader_param/normalmap", n_map_tex)
	mesh_instance.mesh.material.set("shader_param/splatmap", splatmap)#s_map_tex)
	
	mesh_instance.mesh.material.set("shader_param/height_delta", height)
	
	mesh_instance.mesh.material.set("shader_param/red_scale", red_channel_scale)
	mesh_instance.mesh.material.set("shader_param/red_diffuse", red_channel_diffuse)
	mesh_instance.mesh.material.set("shader_param/red_normal", red_channel_normal)
	mesh_instance.mesh.material.set("shader_param/red_roughness", red_channel_roughness)
	mesh_instance.mesh.material.set("shader_param/red_ao", red_channel_ao)
	
	mesh_instance.mesh.material.set("shader_param/green_scale", green_channel_scale)
	mesh_instance.mesh.material.set("shader_param/green_diffuse", green_channel_diffuse)
	mesh_instance.mesh.material.set("shader_param/green_normal", green_channel_normal)
	mesh_instance.mesh.material.set("shader_param/green_roughness", green_channel_roughness)
	mesh_instance.mesh.material.set("shader_param/green_ao", green_channel_ao)
	
	mesh_instance.mesh.material.set("shader_param/blue_scale", blue_channel_scale)
	mesh_instance.mesh.material.set("shader_param/blue_diffuse", blue_channel_diffuse)
	mesh_instance.mesh.material.set("shader_param/blue_normal", blue_channel_normal)
	mesh_instance.mesh.material.set("shader_param/blue_roughness", blue_channel_roughness)
	mesh_instance.mesh.material.set("shader_param/blue_ao", blue_channel_ao)
	
	
func process_images():
	size = Vector2(heightmap.get_width(), heightmap.get_height())
	
	h_map_img = heightmap.duplicate(true)
	h_map_img.convert(Image.FORMAT_RF)
	
	h_map_tex.create_from_image(heightmap.duplicate(true))
	
	var n_map_tmp : Image = heightmap.duplicate(true)
	n_map_tmp.bumpmap_to_normalmap()
	n_map_tex.create_from_image(n_map_tmp)
	
	
func configure_mesh():
	mesh_instance.mesh = PlaneMesh.new()
	mesh_instance.mesh.size = size
	mesh_instance.mesh.subdivide_width = size.x - 1
	mesh_instance.mesh.subdivide_depth = size.y - 1
	mesh_instance.mesh.set("material", terrain_shader)
