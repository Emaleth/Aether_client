extends Spatial

onready var name_label = $Viewport/vbox/Name
onready var guild_label = $Viewport/vbox/Guild
onready var title_lable = $Viewport/vbox/Title
onready var health_bar = $Viewport/vbox/Heatlh
onready var viewport = $Viewport
onready var sprite3d = $Sprite3D


func _ready() -> void:
	sprite3d.texture = viewport.get_texture()

func conf(stats = {}, res = {}) -> void:
	name_label.text = stats.name
	title_lable.text = stats.title
	guild_label.text = stats.guild
	health_bar.conf(res.maximum, res.current, Color.red)

func upd(res):
	health_bar.updt(res.current, res.maximum)

