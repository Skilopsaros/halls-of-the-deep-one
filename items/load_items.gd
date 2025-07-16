extends Node2D

var all_items:Dictionary

func _ready() -> void:
	all_items = read_from_JSON("res://items/items.json")
	for key in all_items.keys():
		all_items[key]["key"] = key

func read_from_JSON(path) -> Variant:
	var file := FileAccess.open(path, FileAccess.READ)
	var json := JSON.new()
	var content := file.get_as_text()
	var error := json.parse(content)
	var data:Variant
	if error == OK:
		data = json.data
	else:
		print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())

	file.close()
	return data

func get_item_by_key(key) -> Dictionary:
	if all_items and all_items.has(key):
		return all_items[key].duplicate(true)
	return {}
