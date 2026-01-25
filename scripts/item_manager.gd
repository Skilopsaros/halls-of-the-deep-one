extends Node

# TODO: iterate over the res://resources/items folder and make a big list of all items iside
# and make it a dictionary where based on a key defined in the item ressource we can fetch the respective item data
# to end the time of having the file name used

func get_item_by_name(key:String) -> ItemObject:
	var item:Item = load("res://resources/items/%s.tres" % key) as Item
	var item_object := ItemObject.constructor(item)
	if len(item.alternative_textures) != 0:
		var rng := RandomNumberGenerator.new()
		var texture_selection:int = rng.randi_range(0, len(item.alternative_textures))
		if texture_selection != 0:
			item_object.texture = item.alternative_textures[texture_selection-1]
		else:
			item_object.texture = item.texture
	
	if item is ContainerItem:
		var inventory:Inventory = get_node("/root/Main").inventory_manager.add_inventory(item.cols,item.rows,item.title,false,true)
		item_object.inventory = inventory
		inventory.hide()
	self.add_child(item_object) # so it's ready function is called and it has a parent to be re-parented from
	return item_object
