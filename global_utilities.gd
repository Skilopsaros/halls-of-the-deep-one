extends Node2D

var all_items

func _ready():
	all_items = read_from_JSON("res://json/items.json")
	for key in all_items.keys():
		all_items[key]["key"] = key

func read_from_JSON(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.new()
	var content = file.get_as_text()
	var error = json.parse(content)
	var data
	if error == OK:
		data = json.data
	else:
		print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())

	file.close()
	return data

func get_item_by_key(key):
	if all_items and all_items.has(key):
		return all_items[key].duplicate(true)
