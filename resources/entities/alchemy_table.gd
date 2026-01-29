extends EntityData
class_name AlchemyTable

@export var skin: Texture = load("res://graphics/entities/alchemy_table.png")
@export var pillage_items: Array[String] = ["empty_bottle"]
@export var experiment_threshold: int = 10
@export var experiment_items: Array[String] = ["strange_brew"]
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
			"text": "Use a liquid to get various effects.",
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
		inventory_manager.display_hidden_inventory_with_items(experiment_items)
	else:
		character.take_insanity(experiment_insanity)
	entity_node.clear_self()

func pillage(entity_node:Entity):
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
	inventory_manager.display_hidden_inventory_with_items(pillage_items)
	entity_node.clear_self()

func alchemise(entity_node:Entity):
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
	var alchemy_table_inventory := inventory_manager.show_input_inventory(4,4,[Enums.item_tags.liquid],"Add a Liquid")
	alchemy_table_inventory.connect("inventory_hiding", alchemise_after_closed_inventory.bind(entity_node))
	
func alchemise_after_closed_inventory(inventory:Inventory, entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	if inventory.items.get_children():
		print(inventory.items.get_children())
		for item in inventory.items.get_children():
			print(item.data.name)
			if item.data.name == "strange_brew":
				character.change_stat(Enums.stats.occult, 1)
			if item.data.name == "acid":
				character.heal_insanity(10)
			if item.data.name == "blood":
				character.heal_damage(10)
			if item.data.name == "ectoplasm":
				character.change_stat(Enums.stats.perception, 1)
		var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
		inventory_manager.display_hidden_inventory_with_items(["empty_bottle"])
		entity_node.clear_self()


 
