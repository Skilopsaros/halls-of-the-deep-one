extends EntityData
class_name WizardStudy

@export var skin: Texture = load("res://graphics/entities/master_poisoner.png")
@export var insanity: int = 12
@export var threshold: int = 10
@export var loot_items: Array[String] = ["silver_coin", "silver_coin", "empty_bottle", "knife"]
@export var pillage_item_table: Array[String] = ["acid", "empty_bottle", "ectoplasm"]

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Search for a secret compartment",
			"text": "Perception check ("+str(threshold)+"). On success find valuables.",
			"action": search
		},
		{
			"title": "Loot Supplies",
			"text": "Grab whatever the wizard has left behind.",
			"action": pillage
		},
		{
			"title": "Use tome",
			"text": "Use a book to get various effects",
			"action": research
		}
	]
	return(choices)

func search(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats[Enums.stats.perception], threshold)
	if pass_check:
		var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
		inventory_manager.display_hidden_inventory_with_items(loot_items)
	entity_node.clear_self()

func pillage(entity_node:Entity):
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
	inventory_manager.display_hidden_inventory_with_items([pillage_item_table[0]])
	entity_node.clear_self()

func research(entity_node:Entity):
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
	var altar_inventory := inventory_manager.show_input_inventory(4,4,{},[Enums.item_tags.book],"Add a Book")
	altar_inventory.connect("inventory_hiding", research_after_closed_inventory.bind(entity_node))
	
func research_after_closed_inventory(inventory:Inventory, entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	if inventory.items:
		for item in inventory.items.get_children():
			if item.data.name == "cursed_volume":
				character.take_insanity(insanity)
				entity_node.get_node("/root/Main/InventoryLayer").player_inventory.activate_random_slot()
		entity_node.clear_self()
 
func randomise(level_data):
	var loot_table: Array[String] = loot_table_to_array(level_data.loot_table)
	loot_table.shuffle()
	pillage_item_table.shuffle()
	loot_items = []
	for i in range(randi_range(3,4)):
		if len(loot_table) > i:
			loot_items.append(loot_table[i])
