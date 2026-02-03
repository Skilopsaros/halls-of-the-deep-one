extends EntityData
class_name Bookshelf

@export var skin: Texture = load("res://graphics/entities/master_poisoner.png")
@export var insanity: int = 10
@export var threshold: int = 10
@export var occ_increase: int = 2
@export var items = ["silver_coin", "silver_coin", "empty_bottle", "knife"]

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Search for a secret compartment",
			"text": "Perception check ("+str(threshold)+"). On success find loot",
			"action": search
		},
		{
			"title": "Pillage",
			"text": "Grab a book.",
			"action": pillage
		},
		{
			"title": "Research",
			"text": "Increase occult by "+str(occ_increase)+", but take "+str(insanity)+" insanity.",
			"action": research
		}
	]
	return(choices)

func search(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats[Enums.stats.perception], threshold)
	if pass_check:
		var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
		inventory_manager.display_hidden_inventory_with_items(items)
	entity_node.clear_self()

func pillage(entity_node:Entity):
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
	inventory_manager.display_hidden_inventory_with_items(["cursed_volume"])
	entity_node.clear_self()

func research(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	character.take_insanity(insanity)
	character.change_stat(Enums.stats.occult, occ_increase)
	entity_node.clear_self()
 
func randomise(level_data):
	var loot_table: Array[String] = loot_table_to_array(level_data.loot_table)
	loot_table.shuffle()
	items = []
	for i in range(randi_range(2,5)):
		if len(loot_table) > i:
			items.append(loot_table[i])
	print(items)
