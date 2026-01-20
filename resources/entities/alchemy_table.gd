extends EntityData
class_name AlchemyTable

@export var skin: Texture = load("res://graphics/entities/master_poisoner.png")
@export var pillage_inventory_size: Vector2 = Vector2(1,1)
@export var pillage_items: Dictionary[String, int] = {"empty_bottle":0}
@export var experiment_threshold: int = 10
@export var experiment_inventory_size: Vector2 = Vector2(1,1)
@export var experiment_items: Dictionary[String, int] = {"strange_brew":0}
@export var experiment_insanity: int = 4

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Pillage",
			"text": "Search the table for anything usable.",
			"action": pillage
		},
		{
			"title": "Alchemise",
			"text": "Add a liquid to get various effects.",
			"action": alchemise
		},
		{
			"title": "Experiment",
			"text": "Occult check ("+str(experiment_threshold) + "). On success create something, on failiure take "+ str(experiment_insanity)+ "insanity" ,
			"action": experiment
		}
	]
	return(choices)

func experiment(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats[Enums.stats.occult], experiment_threshold)
	if pass_check:
		var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
		var alchemy_table_inventory := inventory_manager.add_inventory(experiment_inventory_size.x,experiment_inventory_size.y,"Alchemy Table")
		for item in pillage_items:
			alchemy_table_inventory.add_item(ItemManager.get_item_by_name(item), experiment_items[item])
	else:
		character.take_insanity(experiment_insanity)
	entity_node.clear_self()

func pillage(entity_node:Entity):
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
	var alchemy_table_inventory := inventory_manager.add_inventory(pillage_inventory_size.x,pillage_inventory_size.y,"Alchemy Table")
	for item in pillage_items:
		alchemy_table_inventory.add_item(ItemManager.get_item_by_name(item), pillage_items[item])
	entity_node.clear_self()

func alchemise(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
	var alchemy_table_inventory := inventory_manager.add_inventory(4,4,"Add a Liquid")
	alchemy_table_inventory.filters = [Enums.item_tags.liquid]
	alchemy_table_inventory.closes_on_item_placement = true
	alchemy_table_inventory.connect("inventory_closing", alchemise_after_closed_inventory.bind(entity_node))
	
func alchemise_after_closed_inventory(inventory, entity_node):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	if inventory.items:
		for item in inventory.items.values():
			if item.name == "strange_brew":
				character.heal_insanity(5)
			if item.name == "blood":
				character.heal_damage(5)
		entity_node.clear_self()


 
