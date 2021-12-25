extends PanelContainer

onready var label = $Label


func _process(_delta: float) -> void:
	set_interaction_hint(GlobalVariables.interactable, 1, "K")


func set_interaction_hint(m_interact_with : Object, m_distance : float, m_key : String):
	if m_interact_with == null:
		hide()
	else:
		label.text = "[%s] %s [%sm]" % [m_key, m_interact_with.name, m_distance]
		show()
