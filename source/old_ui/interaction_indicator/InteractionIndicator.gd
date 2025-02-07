extends PanelContainer

onready var label = $PanelContainer/Label


func _process(_delta: float) -> void:
	set_interaction_hint(GlobalVariables.interactable, 1, "I")


func set_interaction_hint(m_interact_with : Object, m_distance : float, m_key : String):
	if m_interact_with == null:
		hide()
	else:
		if GlobalVariables.interactable.is_in_group("loot"):
			label.text = "[%s] %sx%s [%sm]" % [m_key, m_interact_with.item, m_interact_with.amount, m_distance]
		if GlobalVariables.interactable.is_in_group("shop"):
			label.text = "[%s] %s [%sm]" % [m_key, m_interact_with, m_distance]
		show()
