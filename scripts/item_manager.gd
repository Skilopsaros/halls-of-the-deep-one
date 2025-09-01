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
	if item is ContainerItem:
		var inventory:Inventory = get_node("/root/Main").inventory_manager.add_inventory(item.cols,item.rows,item.title,false,true)
		item.inventory = inventory
		inventory.hide()
	return item
