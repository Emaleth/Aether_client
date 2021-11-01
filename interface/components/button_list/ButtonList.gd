extends PopupPanel

	
func configure(_buttons : Array, _slot, _position : Vector2):
	hide()

	for i in $VBoxContainer.get_children():
		i.queue_free() 

	yield(get_tree(), "idle_frame")
	
	$VBoxContainer.rect_size = Vector2.ZERO
	rect_size = Vector2.ZERO
	
	for i in _buttons:
		var new_button = Button.new()
		new_button.text = i
		$VBoxContainer.add_child(new_button, true)
		new_button.connect("pressed", _slot, "button_pressed", [i])
		new_button.connect("pressed", self, "hide")

	rect_global_position = _position

	show_modal()
