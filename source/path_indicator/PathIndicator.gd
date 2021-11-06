extends Position3D

var time := 0.0

var rotation_delta := 20 
var rotation_frequency := 2

var bounce_delta := 0.2
var bounce_frequency := 3

var bounce_offset := 0.5
var last_point_min_distance := 1.2

onready var horizonatal_sprite := $HorizontalSprite
onready var vertical_sprite := $VerticalSprite
onready var path_sprite := $PathSprite
onready var path_curve := $Path
onready var path_container := $PathContainer


func _ready() -> void:
	path_sprite.hide()

func configure(_pos, _path):
	global_transform.origin = _pos
	clear_path_point_sprites()
	display_path_sprites(_pos, _path)
	
func _physics_process(delta: float) -> void:
	animate(delta)
	
func animate(_delta):
	time = wrapf(time + _delta, 0, 1000)
	var cosine_rotation = cos(time * rotation_frequency) * rotation_delta
	var cosine_bounce = cos(time * bounce_frequency) * bounce_delta
	horizonatal_sprite.rotation.y = deg2rad(cosine_rotation)
	vertical_sprite.transform.origin.y = bounce_offset + cosine_bounce

func clear_path_point_sprites():
	path_curve.curve.clear_points()
	for i in path_container.get_children(): 
		i.queue_free()

func display_path_sprites(_pos : Vector3, _path):
	for i in _path:
		path_curve.curve.add_point(i)
		
	for i in path_curve.curve.get_baked_points().size():
		if _pos.distance_to(path_curve.curve.get_baked_points()[i]) > last_point_min_distance:
			var new_path_point = path_sprite.duplicate()
			path_container.add_child(new_path_point)
			new_path_point.global_transform.origin = path_curve.curve.get_baked_points()[i] + Vector3(0, 0.1, 0)
			new_path_point.show()
