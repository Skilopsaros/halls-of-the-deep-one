extends EntityData
class_name Anvil

@export var skin: Texture = load("res://graphics/entities/anvil.png")

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Craft Ingot",
			"text": "Use an ingot to craft something",
			"action": craft
		},
		{
			"title": "Ignore",
			"text": "Ignore the Anvil",
			"action": ignore
		},
		{
			"title": "Repair a Broken Weapon",
			"text": "Use an ingot to repair a broken weapon",
			"action": repair,
			"requirement":requirement_to_fix
		}
	]
	return(choices)

func requirement_to_fix(entity_node:Entity) -> bool:
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
	var inventory_tags: Dictionary[String, Array] = inventory_manager.get_inventory_tags()
	if Enums.item_tags.ingot in inventory_tags["inventory"] and (
		Enums.item_tags.broken in inventory_tags["inventory"] or 
		Enums.item_tags.broken in inventory_tags["weapon"] or  
		Enums.item_tags.broken in inventory_tags["armour"] or  
		Enums.item_tags.broken in inventory_tags["accessory"]
	):
		return(true)
	return(false)

func requirement_to_create(entity_node:Entity) -> bool:
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
	var inventory_tags: Dictionary[String, Array] = inventory_manager.get_inventory_tags()
	if Enums.item_tags.ingot in inventory_tags["inventory"]:
		return(true)
	return(false)

func ignore(entity_node:Entity) -> void:
	entity_node.clear_self()

func craft(entity_node:Entity) -> void:
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
	var anvil_inventory := inventory_manager.show_input_inventory(4,4,[Enums.item_tags.ingot],"Add an Ingot")
	anvil_inventory.connect("inventory_hiding", craft_after_closed_inventory.bind(entity_node))

func repair(entity_node:Entity) -> void:
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
	var anvil_table_inventory := inventory_manager.show_input_inventory(8,8,[Enums.item_tags.ingot, Enums.item_tags.broken],"Ingot and Broken equipment")
	anvil_table_inventory.closing_check = repair_close_check # wtf
	anvil_table_inventory.connect("inventory_hiding", repair_after_closed_inventory.bind(entity_node))

func repair_close_check(inventory:Inventory) -> bool:
	var tags = inventory.get_contained_tags()
	return((Enums.item_tags.ingot in tags) and (Enums.item_tags.broken in tags))

func craft_after_closed_inventory(inventory:Inventory, entity_node:Entity) -> void:
	if inventory.items:
		var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
		for item in inventory.items.values():
			if item.name == "magic_ingot":
				inventory_manager.display_hidden_inventory_with_items(["amulet"])
			if item.name == "metal_ingot":
				inventory_manager.display_hidden_inventory_with_items(["chain_mail"])
		entity_node.clear_self()

func repair_after_closed_inventory(inventory:Inventory, entity_node:Entity) -> void:
	if inventory.items:
		var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
		var ingot_type = ""
		for item in inventory.items.values():
			if item.name == "magic_ingot":
				ingot_type = "magic"
			if item.name == "metal_ingot":
				ingot_type = "metal"
		for item in inventory.items.values():
			if item.name == "broken_sword":
				if ingot_type == "magic":
					inventory_manager.display_hidden_inventory_with_items(["epic_sword"])
				elif ingot_type == "metal":
					inventory_manager.display_hidden_inventory_with_items(["sword"])
		entity_node.clear_self()
