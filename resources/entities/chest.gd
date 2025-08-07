extends EntityData
class_name EntityChestData

@export var chest_size: Vector2 = Vector2(5,5)
@export var items: Dictionary[String, int] = {"coin":0}

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
			{
				"title": "Check for traps",
				"text": "Perception check (17). On success, reveal if chest is trapped. On failure, take 4 insanity.",
				"action": check_for_traps
			},
			{
				"title": "Open chest",
				"text": "Open the chest. If the chest is trapped take 20-agility damage",
				"action": open_chest
			},
			{
				"title": "Ignore",
				"text": "Ignore the chest. Do not open",
				"action": ignore
			}
		]
	return(choices)

func ignore(entity_node:Entity):
	entity_node.clear_self()

func check_for_traps(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats["perception"], 17)
	if pass_check:
		var choices: Array[Dictionary] = [
			{
				"title": "Open chest",
				"text": "Open the chest",
				"action": open_chest
			},
			{
				"title": "Ignore",
				"text": "Ignore the chest. Do not open",
				"action": ignore
			}
		]
		entity_node.get_node("/root/Main/ChoisesContainer").add_options_from_options_list(choices, entity_node)
	else:
		character.take_insanity(4)
		
func open_chest(entity_node:Entity):
	print("open")
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
	var chest := inventory_manager.add_inventory(chest_size.x,chest_size.y,"Chest")
	for item in items:
		chest.add_item(ItemManager.get_item_by_name(item), items[item])
	entity_node.clear_self()
