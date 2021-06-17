extends Node

var item_db = "res://data/item_data.csv"
var spell_db = "res://data/spell_data.csv"

func _ready():
	item_db = convert_csv_data_to_dictionary(get_data_from_csv(item_db))
	spell_db = convert_csv_data_to_dictionary(get_data_from_csv(spell_db))
	
func get_data_from_csv(data_file_path):
	var maindata = {}
	var file = File.new()
	file.open(data_file_path, file.READ)
	while !file.eof_reached():
		var data_set = Array(file.get_csv_line())
		maindata[maindata.size()] = data_set
	file.close()
	return maindata

func convert_csv_data_to_dictionary(data):
	var db_dict = {}
	var keys = []
	for row in data:
		if row == 0:
			keys = data.get(row)
		else:
			if data.get(row)[0]: # UID
				var entry = {}
				for k in keys.size():
					if k != 0:
						if data.get(row)[k] == "true":
							data.get(row)[k] = true
						elif data.get(row)[k] == "false":
							data.get(row)[k] = false
						elif data.get(row)[k] == "null":
							data.get(row)[k] = null
						elif "{" in data.get(row)[k] and "}" in data.get(row)[k]:
							data.get(row)[k] = JSON.parse(data.get(row)[k]).result
						entry[str(keys[k])] = data.get(row)[k]
				db_dict[data.get(row)[0]] = entry

	return db_dict

			


