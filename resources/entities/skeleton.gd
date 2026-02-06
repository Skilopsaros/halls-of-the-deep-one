extends EntityData
class_name Skeleton

@export var skin: Texture = load("res://graphics/entities/master_poisoner.png")
@export var damage: int = 10
@export var insanity: int = 10
@export var threshold: int = 6

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Fight",
			"text": "Take " + str(damage) + " - POW damage",
			"action": lose_health
		},
		{
			"title": "Turn",
			"text": "Take " + str(insanity) + " - OCC insanity",
			"action": gain_insanity
		},
		{
			"title": "Use Holly Symbol",
			"text": "Destroy the monster with your holly symbol",
			"action": use_holly_symbol,
			"requirement":requirement_to_skip
		}
	]
	return(choices)

func requirement_to_skip(entity_node:Entity):
	var player_inventory: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_inventory
	for item in player_inventory.items.get_children():
		if item.data.name == "holly_symbol":
			return(true)
	return(false)

func use_holly_symbol(entity_node:Entity):
	var player_inventory: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_inventory
	if player_inventory.items:
		for item in player_inventory.items.get_children():
			if item.data.name == "torch":
				player_inventory.remove_item(item)
		entity_node.clear_self()
 

func lose_health(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	character.take_damage(damage-character.stats[Enums.stats.power])
	entity_node.clear_self()

func gain_insanity(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	character.take_insanity(insanity-character.stats[Enums.stats.occult])
	entity_node.clear_self()
