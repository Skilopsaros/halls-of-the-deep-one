extends EntityData
class_name Ghost

@export var skin: Texture = load("res://graphics/entities/ghost.png")
@export var damage: int = 2
@export var insanity: int = 2
@export var threshold: int = 12

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Banish",
			"text": "Occult check, lose " + str(damage) + " -OCC health",
			"action": banish
		},
		{
			"title": "Pass through",
			"text": "Power check. On failure take " + str(insanity) + " insanity",
			"action": pass_through
		},
		{
			"title": "Capture",
			"text": "Capture the monster in an empty bottle",
			"action": capture,
			"requirement":requirement_to_capture
		}
	]
	return(choices)

func requirement_to_capture(entity_node:Entity):
	var player_inventory: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_inventory
	for item in player_inventory.items.get_children():
		if item.data.name == "empty_bottle":
			return(true)
	return(false)

func capture(entity_node:Entity):
	var player_inventory: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_inventory
	if player_inventory.items.get_children():
		for item in player_inventory.items.get_children():
			if item.data.name == "empty_bottle":
				var item_coords: Vector2i = item.location
				player_inventory.remove_item(item)
				player_inventory.add_item(ItemManager.get_item_by_name("ectoplasm"), item_coords)
				break
		entity_node.clear_self()

func banish(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	character.take_damage(damage-character.stats[Enums.stats.occult])
	entity_node.clear_self()

func pass_through(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats[Enums.stats.power], threshold)
	if not pass_check:
		character.take_insanity(insanity)
	entity_node.clear_self()
 
