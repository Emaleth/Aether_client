extends CanvasLayer

# DEBUG PANELS
onready var latency_label = $MarginContainer/DebugInfoPanels/Latency/Label
onready var target_label = $MarginContainer/DebugInfoPanels/Target/Label
# resource bars
onready var health_bar = $MarginContainer/BottomMiddlePanel/BottomMiddle/HBoxContainer/HealthBar
onready var mana_bar = $MarginContainer/BottomMiddlePanel/BottomMiddle/HBoxContainer/ManaBar
# TOP RIGHT
onready var clock_label = $MarginContainer/TopRightPanel/VBoxContainer/ServerClock/Label
onready var minimap_module = $MarginContainer/TopRightPanel/VBoxContainer/MiniMap

onready var eq = $MarginContainer/Equipment
onready var skill_panel = $MarginContainer/BottomMiddlePanel/BottomMiddle/SkillPanel

func _ready() -> void:
	eq.button_list = $Floating/ButtonList
	Server.connect("update_equipment_data", eq, "configure")
	Server.request_equipment_data()
	
func get_minimap_pivot_path():
	return minimap_module.get_pivot_path()
	
func _physics_process(_delta: float) -> void:
	format_time()
	latency_label.text = "Latency: %sms" % (Server.latency)

func format_time():
	var date_dict = OS.get_datetime_from_unix_time(Server.client_clock / 1000)
	var hour : String
	var minute : String
	var second : String
	if date_dict["hour"] < 10:
		hour = "0" + str(date_dict["hour"])
	else:
		hour = str(date_dict["hour"])
		
	if date_dict["minute"] < 10:
		minute = "0" + str(date_dict["minute"])
	else:
		minute = str(date_dict["minute"])
		
	if date_dict["second"] < 10:
		second = "0" + str(date_dict["second"])
	else:
		second = str(date_dict["second"])
		
	clock_label.text = "%s:%s:%s" % [hour, minute, second]
			
func update_health_bar(_hp, _max_hp):
	health_bar.update_ui(_hp, _max_hp)
	
func update_mana_bar(_mana, _max_mana):
	mana_bar.update_ui(_mana, _max_mana)
	

#var target = null
#func show_tooltip(_target):
#	target = _target
#	target_label.text = "Mouse Target: %s" % _target 
