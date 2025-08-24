extends Node

func get_item_by_name(key:String)->Item:
	var item:Item = load("res://resources/items/%s.tres" % key) as Item
	item = item.duplicate()
	if len(item.alternative_textures) != 0:
		var rng := RandomNumberGenerator.new()
		var texture_selection:int = rng.randi_range(0, len(item.alternative_textures))
		if texture_selection != 0:
			item.texture = item.alternative_textures[texture_selection-1]
	item._ready()
	return item
