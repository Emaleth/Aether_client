extends PanelContainer


onready var gold_label = $Label


func configure(_data : Dictionary):
	if _data.size() > 0:
		gold_label.text = str(_data["gold"])
	
	
func _ready() -> void:
	configure(GlobalVariables.currency_data)

