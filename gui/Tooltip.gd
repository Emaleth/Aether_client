extends PanelContainer

onready var container = $VBoxContainer
onready var title_label = $VBoxContainer/Title
onready var icon_rect = $VBoxContainer/Icon
onready var body_label = $VBoxContainer/Body
onready var stats_label = $VBoxContainer/Stats
onready var footnote_label = $VBoxContainer/Footnote

onready var size_fix = $SizeFix
onready var fix_title_label = $SizeFix/Title
onready var fix_icon_rect = $SizeFix/Icon
onready var fix_body_label = $SizeFix/Body
onready var fix_stats_label = $SizeFix/Stats
onready var fix_footnote_label = $SizeFix/Footnote


func conf(name : String = "", icon : Texture = null, description : String = "", stats : Dictionary = {}):
	yield(self, "ready")
	if name == "":
		title_label.hide()
		fix_title_label.hide()
	else:
		title_label.bbcode_text = name
		fix_title_label.text = name
		
	if icon == null:
		icon_rect.hide()
		fix_icon_rect.hide()
	else:
		icon_rect.texture = icon
		fix_icon_rect.texture = icon
		
	if description == "":
		body_label.hide()
		fix_body_label.hide()
	else:
		body_label.bbcode_text = description
		fix_body_label.text = description
		
	if stats.size() == 0:
		stats_label.hide()
		fix_stats_label.hide()
	else:
		for i in stats:
			if stats_label.bbcode_text != "":
				stats_label.bbcode_text += "\n"
			if fix_stats_label.text != "":
				fix_stats_label.text += "\n"
			stats_label.bbcode_text += (str(i) + " : " + str(stats.get(i))) 
			fix_stats_label.text += (str(i) + " : " + str(stats.get(i))) 
		
	size_fix.modulate.a = 0

func _on_VBoxContainer_sort_children() -> void:
	rect_size = container.rect_size

