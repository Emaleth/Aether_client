extends PanelContainer

onready var label = $MarginContainer/Label


func conf(name : String = "", description : String = "", stats : String = ""):
	yield(self, "ready")
	
	var new_text = ""
	if name != "":
		new_text += name
	if description != "":
		new_text += description
	if stats != "":
		new_text += stats
		
	label.text = new_text
