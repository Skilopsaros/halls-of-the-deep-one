extends EntityData
class_name Infuser

@export var skin: Texture = load("res://graphics/entities/carcas.png")

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Ignore",
			"text": "Ignore the carcas",
			"action": ignore
		},
		{
			"title": "Infuse a metal ingot with ectoplasm",
			"text": "Use a metal ingot and ectoplasm, gain a magic ingot",
			"action": magic_ingot,
			"requirement":requirement_magic_ingot
		},
		{
			"title": "Infuse ectoplasm with blood",
			"text": "Use blood and ectoplasm, gain a strange brew",
			"action": strange_brew,
			"requirement":requirement_strange_brew
		}
	]
	return(choices)

func requirement_magic_ingot(entity_node:Entity) -> bool:
	var player_inventory: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_inventory
	var has_ectoplasm: bool = false
	var has_metal_ingot: bool = false
	for item in player_inventory.items.get_children():
		if item.data.name == "ectoplasm":
			has_ectoplasm = true
		elif item.data.name == "metal_ingot":
			has_metal_ingot = true
	return(has_ectoplasm and has_metal_ingot)
	
func requirement_strange_brew(entity_node:Entity) -> bool:
	var player_inventory: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_inventory
	var has_ectoplasm: bool = false
	var has_blood: bool = false
	for item in player_inventory.items.get_children():
		if item.data.name == "ectoplasm":
			has_ectoplasm = true
		elif item.data.name == "blood":
			has_blood = true
	return(has_ectoplasm and has_blood)

func magic_ingot(entity_node:Entity):
	use_x_and_y_get_z(entity_node, "ectoplasm", "metal_ingot", ["magic_ingot", "empty_bottle"])

func strange_brew(entity_node:Entity):
	use_x_and_y_get_z(entity_node, "ectoplasm", "blood", ["strange_brew", "empty_bottle"])

func use_x_and_y_get_z(entity_node:Entity, x:String, y:String, z:Array[String]) -> void:
	var player_inventory: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_inventory
	var has_x: bool = false
	var has_y: bool = false
	var x_node: Node
	var y_node: Node
	if player_inventory.items:
		for item in player_inventory.items.get_children():
			if item.data.name == x:
				has_x = true
				x_node = item
				break
		for item in player_inventory.items.get_children():
			if item.data.name == y:
				has_y = true
				y_node = item
				break
		if has_x and has_y:
			player_inventory.remove_item(x_node)
			player_inventory.remove_item(y_node)
			var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
			inventory_manager.display_hidden_inventory_with_items(z)
			entity_node.clear_self()
 
func ignore(entity_node:Entity) -> void:
	entity_node.clear_self()
