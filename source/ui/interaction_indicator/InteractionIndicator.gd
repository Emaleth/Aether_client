extends PanelContainer

onready var label = $Label


func _process(delta: float) -> void:
	set_interaction_hint(GlobalVariables.target.name, 1, "K")


func set_interaction_hint(m_interact_with : String, m_distance : float, m_key : String):
	if m_interact_with == null:
		hide()
	else:
		label.text = "[%s] %s [%s]" % [m_key, m_interact_with, m_distance]
		show()
