extends PanelContainer

var window_height_in_slots = 5
var grid_v_separation = 4

onready var slot_grid = $VBoxContainer/Slots/ScrollContainer/grid
onready var scroll : ScrollContainer = $VBoxContainer/Slots/ScrollContainer
onready var button_list = $VBoxContainer/Buttons/SlotSelector
onready var slot_path = preload("res://gui/Slot.tscn")
	
func _ready() -> void:
#	scrollbar_theme()
	scroll.rect_min_size.y = ((window_height_in_slots * 40) + ((window_height_in_slots -1) * grid_v_separation))
	connect_button()
	show_slot_type("inventory")
	$Close/TextureRect.self_modulate = Global.close_button
	
func conf(actor, quantity_panel):
	for old_slot in slot_grid.get_children():
		slot_grid.remove_child(old_slot)
		old_slot.queue_free()
	for i in actor.inventory:
		var new_slot = slot_path.instance()
		slot_grid.add_child(new_slot)
		new_slot.conf(actor, i, "inventory", quantity_panel)
		
func show_slot_type(slot_type : String = ""):
	for slot in slot_grid.get_children():
		if slot_type == "inventory":
			slot.show()
		else:
			if slot.aactor.get(slot.ttype).get(slot.sslot).item:
				if slot_type in DB.item_db.get(slot.aactor.get(slot.ttype).get(slot.sslot).item).TYPE:
					slot.show()
				else:
					slot.hide()
	for i in button_list.get_children():
		if i is Button:
			if str(i.name).to_lower() == slot_type:
				i.self_modulate = Global.toggle_on
			else:
				i.self_modulate = Global.toggle_off

func connect_button():
	for i in button_list.get_children():
		if i is Button:
			i.connect("pressed", self, "show_slot_type", [str(i.name).to_lower()])

#func scrollbar_theme():
#	var grabber = StyleBoxTexture.new()
#	grabber.texture = preload("res://textures/ui/grabber.png")
#	grabber.margin_top = 6
#	grabber.margin_bottom = 6
#	var grabber_bg = StyleBoxTexture.new()
#	grabber_bg.texture = preload("res://textures/ui/scrollbar_bg.png")
#	scroll.get_v_scrollbar().add_stylebox_override("grabber_highlight", grabber)
#	scroll.get_v_scrollbar().add_stylebox_override("grabber", grabber)
#	scroll.get_v_scrollbar().add_stylebox_override("grabber_pressed", grabber)
#	scroll.get_v_scrollbar().add_stylebox_override("scroll", grabber_bg)
#	scroll.get_v_scrollbar().add_stylebox_override("scroll_focus", grabber_bg) 

func _on_Inventory_sort_children() -> void:
	var offset = 4
	$Close.rect_position = Vector2(rect_size.x - $Close.rect_size.x / 2 - offset, -$Close.rect_size.y / 2 + offset) 

func _on_Close_pressed() -> void:
	hide()
