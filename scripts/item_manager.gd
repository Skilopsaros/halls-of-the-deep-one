extends Node

func get_item_by_name(key:String)->Item:
	var item:Item = load("res://resources/items/%s.tres" % key) as Item
	item = item.duplicate()
	item._ready()
	return item
