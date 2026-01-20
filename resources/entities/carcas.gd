extends EntityData
class_name Carcas

@export var skin: Texture = load("res://graphics/entities/carcas.png")
@export var health: int = 4
@export var insanity: int = 6

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Ignore",
			"text": "Ignore the carcas",
			"action": ignore
		},
		{
			"title": "Eat",
			"text": "Gain " + str(health) + " health and " +str(insanity) + " insanity.",
			"action": harvest
		},
		{
			"title": "Harvest Blood",
			"text": "Fill an empty bottle with blood",
			"action": harvest,
			"requirement":requirement_to_harvest
		}
	]
	return(choices)

func requirement_to_harvest(entity_node:Entity) -> bool:
	var player_inventory: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_inventory
	for item in player_inventory.items.values():
		if item.name == "empty_bottle":
			return(true)
	return(false)

func harvest(inventory, entity_node) -> void:
	var player_inventory: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_inventory
	if inventory.items:
		var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
		for item_key in inventory.items.keys():
			if inventory.items[item_key].name == "empty_bottle":
				inventory.remove_item(item_key)
				inventory.add_item(ItemManager.get_item_by_name("blood"), item_key)
				break
		entity_node.clear_self()
 
func ignore(entity_node:Entity) -> void:
	entity_node.clear_self()

func eat(entity_node:Entity) -> void:
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	character.take_insanity(insanity)
	character.heal_health(health)
	entity_node.clear_self()
