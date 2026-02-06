extends EntityData
class_name RagCreature

@export var skin: Texture = load("res://graphics/entities/rag_creature.png")
@export var insanity: int = 8
@export var damage: int = 8
@export var threshold: int = 8
@export var treasure: Array[String] = ["silver_coin", "silver_coin"]

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Wear",
			"text": "Take " + str(insanity) + " insanity, but gain an inventory slot",
			"action": wear
		},
		{
			"title": "Disenchant",
			"text": "Occult check ("+str(threshold)+"). On success, gain the living scarf. On failure take " + str(damage) + " damage",
			"action": disenchant
		},
		{
			"title": "Burn",
			"text": "Use a torch to get the treasure at the creature's core",
			"action": burn,
			"requirement": requirement_has_torch
		}
	]
	return(choices)

func requirement_has_torch(entity_node:Entity) -> bool:
	var player_inventory: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_inventory
	for item in player_inventory.items.get_children():
		if item.data.name == "torch":
			return(true)
	return(false)

func disenchant(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats[Enums.stats.occult], threshold)
	if not pass_check:
		character.take_damage(damage)
	else:
		var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
		inventory_manager.display_hidden_inventory_with_items(["living_scarf"])
	entity_node.clear_self()

func wear(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	character.take_insanity(insanity)
	var inventory: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_inventory
	inventory.activate_random_slot()
	entity_node.clear_self()

func burn(entity_node:Entity):
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer") 
	var player_inventory: Inventory = inventory_manager.player_inventory
	if player_inventory.items:
		for item in player_inventory.items.get_children():
			if item.data.name == "torch":
				player_inventory.remove_item(item)
		inventory_manager.display_hidden_inventory_with_items(treasure)
		entity_node.clear_self()
 
