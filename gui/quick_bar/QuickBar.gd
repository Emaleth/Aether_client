extends PanelContainer

onready var h_box = $HBoxContainer
	
func conf(quickbar):
	var slots = [] 
	for i in h_box.get_children():
		if not i is VSeparator:
			slots.append(i)
	var index = 0
	for i in quickbar:
		slots[index].conf("quickbar", quickbar, i)
		index += 1

	
