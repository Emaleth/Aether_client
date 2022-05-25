extends PanelContainer


onready var inventory := $Bg/HBoxContainer/RightContainer/RightSector/Inventory
onready var account_info := $Bg/HBoxContainer/LeftContainer/LeftSector/AccountInfoContainer
onready var equipment := $Bg/HBoxContainer/LeftContainer/LeftSector/EquipmentContainer


func _on_Close_pressed() -> void:
	hide()
