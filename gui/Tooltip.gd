extends PanelContainer

onready var container = $VBoxContainer
onready var title_label = $VBoxContainer/TitleContainer/Title
onready var icon_rect = $VBoxContainer/IconContainer/Icon
onready var body_label = $VBoxContainer/BodyContainer/Body
onready var stats_label = $VBoxContainer/StatsContainer/Stats
onready var attributes_label = $VBoxContainer/AttributesContainer/Attributes
onready var footnote_label = $VBoxContainer/FootnoteContainer/Footnote

onready var title_panel = $VBoxContainer/TitleContainer
onready var icon_panel = $VBoxContainer/IconContainer
onready var body_panel = $VBoxContainer/BodyContainer
onready var stats_panel = $VBoxContainer/StatsContainer
onready var attributes_panel = $VBoxContainer/AttributesContainer
onready var footnote_panel = $VBoxContainer/FootnoteContainer

onready var size_fix = $SizeFix
onready var fix_title_label = $SizeFix/TitleContainer/Title
onready var fix_icon_rect = $SizeFix/IconContainer/Icon
onready var fix_body_label = $SizeFix/BodyContainer/Body
onready var fix_stats_label = $SizeFix/StatsContainer/Stats
onready var fix_attributes_label = $SizeFix/AttributesContainer/Attributes
onready var fix_footnote_label = $SizeFix/FootnoteContainer/Footnote

onready var fix_title_panel = $SizeFix/TitleContainer
onready var fix_icon_panel = $SizeFix/IconContainer
onready var fix_body_panel = $SizeFix/BodyContainer
onready var fix_stats_panel = $SizeFix/StatsContainer
onready var fix_attributes_panel = $SizeFix/AttributesContainer
onready var fix_footnote_panel = $SizeFix/FootnoteContainer

func conf(name : String = "", icon : Texture = null, description : String = "", stats : Dictionary = {}, attributes : Dictionary = {}, footnote = ""):
	yield(self, "ready")
	if name == "":
		title_panel.hide()
		fix_title_panel.hide()
	else:
		title_label.bbcode_text = name
		fix_title_label.text = name
		
	if icon == null:
		icon_panel.hide()
		fix_icon_panel.hide()
	else:
		icon_rect.texture = icon
		fix_icon_rect.texture = icon
		
	if description == "":
		body_panel.hide()
		fix_body_panel.hide()
	else:
		body_label.bbcode_text = description
		fix_body_label.text = description
		
	if stats.size() == 0:
		stats_panel.hide()
		fix_stats_panel.hide()
	else:
		var wrf = make_table(stats)
		stats_label.bbcode_text = wrf[0]
		fix_stats_label.text = wrf[1]

		
	if attributes.size() == 0:
		attributes_panel.hide()
		fix_attributes_panel.hide()
	else:
		var wrf = make_table(attributes)
		attributes_label.bbcode_text = wrf[0]
		fix_attributes_label.text = wrf[1]
		
	if footnote == "":
		footnote_panel.hide()
		fix_footnote_panel.hide()
	else:
		footnote_label.bbcode_text = footnote
		fix_footnote_label.text = footnote
		
	size_fix.modulate.a = 0

func _on_VBoxContainer_sort_children() -> void:
	rect_size = container.rect_size

func make_table(dict : Dictionary) -> Array:
	var new_string : String = ""
	var fix_new_string : String = "" 
	new_string += "[table=3]"
	for i in dict:
		new_string += ("[cell]" + str(i) + "[/cell]" + "[cell] : [/cell]" + "[cell]" + str(dict.get(i)) + "[/cell]") 
		fix_new_string += (str(i) + " : " + str(dict.get(i)) + "\n")
	fix_new_string.trim_suffix("\n")

	new_string += "[/table]"
	return [new_string, fix_new_string]
