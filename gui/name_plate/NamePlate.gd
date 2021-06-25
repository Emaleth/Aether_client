extends Spatial

onready var name_label = $Viewport/vbox/Name
onready var guild_label = $Viewport/vbox/Guild
onready var title_lable = $Viewport/vbox/Title
onready var health_bar = $Viewport/vbox/Heatlh
onready var mesh = $MeshInstance
onready var viewport = $Viewport


func conf(stats = {}, res = {}) -> void:
	mesh.get_surface_material(0).albedo_texture = viewport.get_texture()
	name_label.text = stats.name
	title_lable.text = stats.title
	guild_label.text = stats.guild
	health_bar.conf(res.maximum, res.current, Color.red)

func upd(res):
	health_bar.updt(res.health.current, res.health.maximum)

