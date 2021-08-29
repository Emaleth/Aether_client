extends Button

class_name animated_button

enum type {NORMAL, CONFIRM, CANCEL}

export(type) var button_type

onready var tween : Tween = Tween.new()

export var animation_time = 0.2
export var scale_delta = 0.2

func _ready() -> void:
	conf()
	
func _process(_delta: float) -> void:
	rect_pivot_offset = rect_size / 2 
	
func conf():
	add_child(tween)
	connect("pressed", self, "set_anim")
	match button_type:
		type.NORMAL:
			pass
		type.CONFIRM:
			self_modulate = Color.green
		type.CANCEL:
			self_modulate = Color.red
			
func set_anim():
	tween.reset_all()
	match button_type:
		type.NORMAL:
			normal_animation()
		type.CONFIRM:
			confirm_animation()
		type.CANCEL:
			cancel_animation()
	tween.start()

func normal_animation():
	tween.interpolate_property(
		self, 
		"rect_scale", 
		rect_scale, 
		Vector2.ONE + Vector2.ONE * scale_delta, 
		(animation_time / 2), 
		Tween.TRANS_BOUNCE, 
		Tween.EASE_OUT
		)
	tween.interpolate_property(
		self, 
		"rect_scale", 
		rect_scale, 
		Vector2.ONE, 
		(animation_time / 2), 
		Tween.TRANS_BOUNCE, 
		Tween.EASE_OUT, 
		(animation_time / 2)
		)
		
func confirm_animation():
	tween.interpolate_property(
		self, 
		"rect_scale", 
		rect_scale, 
		Vector2.ONE + Vector2.ONE * scale_delta, 
		(animation_time / 2), 
		Tween.TRANS_BOUNCE, 
		Tween.EASE_OUT
		)
	tween.interpolate_property(
		self, 
		"rect_scale", 
		rect_scale, 
		Vector2.ONE, 
		(animation_time / 2), 
		Tween.TRANS_BOUNCE, 
		Tween.EASE_OUT, 
		(animation_time / 2)
		)
		
func cancel_animation():
	tween.interpolate_property(
		self, 
		"rect_scale", 
		rect_scale, 
		Vector2.ONE + Vector2.ONE * scale_delta, 
		(animation_time / 2), 
		Tween.TRANS_BOUNCE, 
		Tween.EASE_OUT
		)
	tween.interpolate_property(
		self, 
		"rect_scale", 
		rect_scale, 
		Vector2.ONE, 
		(animation_time / 2), 
		Tween.TRANS_BOUNCE, 
		Tween.EASE_OUT, 
		(animation_time / 2)
		)
