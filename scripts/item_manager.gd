extends Node

var item_dictionary:Dictionary = {}

const gold_material = preload("res://graphics/materials/gold.tres")
const silver_material = preload("res://graphics/materials/silver.tres")

func initialize_item_dict() -> void:
	var dir := DirAccess.open("res://resources/items")
	if dir == null:
		printerr("Could not open folder")
		return
	dir.list_dir_begin()
	for file:String in dir.get_files():
		var resource := load(dir.get_current_dir() + "/" + file)
		if resource == null:
			print("Failed to load " + file)
			continue
		item_dictionary[resource.name] = resource

func get_item_by_name(key:String) -> ItemObject:
	if len(item_dictionary.keys()) == 0:
		initialize_item_dict();
	var material:int = 0
	if key.begins_with("silver_"):
		material = 1
		key = key.replace("silver","copper")
	elif key.begins_with("gold_"):
		material = 2
		key = key.replace("gold","copper")
		
	var item:Item = item_dictionary[key]
	var item_object := ItemObject.constructor(item)
	if len(item.alternative_textures) != 0:
		var rng := RandomNumberGenerator.new()
		var texture_selection:int = rng.randi_range(0, len(item.alternative_textures))
		if texture_selection != 0:
			item_object.texture = item.alternative_textures[texture_selection-1]
		else:
			item_object.texture = item.texture
	
	if material == 1:
		item_object.material = silver_material
		item_object.data.value *= 5
	elif material == 2:
		item_object.material = gold_material
		item_object.data.value *= 25
	
	if item is ContainerItem:
		var inventory:Inventory = get_node("/root/Main").inventory_manager.add_inventory(item.cols,item.rows,item.title,false,true,true)
		item_object.inventory = inventory
		inventory.hide()
		inventory.is_bag = true
	self.add_child(item_object) # so it's ready function is called and it has a parent to be re-parented from
	
	return item_object
