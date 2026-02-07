extends EntityData
class_name Slime

@export var skin: Texture = load("res://graphics/entities/master_poisoner.png")
@export var damage: int = 9
@export var threshold: int = 10
@export var treasure: Array[String] = ["broken_sword"]

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Fight",
			"text": "Power check (" + str(threshold) + "). On failure take " +str(damage) + " damage.",
			"action": fight
		},
		{
			"title": "Bottle up",
			"text": "Take " +str(damage) + " - AGI damage, fill an empty bottle with acid",
			"action": bottle_up,
			"requirement": requirement_to_bottle
		},
		{
			"title": "Burn",
			"text": "Burn the slime and get the treasure within.",
			"action": burn,
			"requirement":requirement_to_burn
		}
	]
	return(choices)

func requirement_to_bottle(entity_node:Entity) -> bool:
	var player_inventory: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_inventory
	for item in player_inventory.items.get_children():
		if item.data.name == "empty_bottle":
			return(true)
	return(false)

func requirement_to_burn(entity_node:Entity) -> bool:
	var player_inventory: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_inventory
	for item in player_inventory.items.get_children():
		if item.data.name == "torch":
			return(true)
	return(false)

func bottle_up(entity_node:Entity) -> void:
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	var player_inventory: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_inventory
	if player_inventory.items:
		for item in player_inventory.items.get_children():
			if item.data.name == "empty_bottle":
				character.take_damage(damage-character.stats[Enums.stats.power])
				var item_coords: Vector2i = item.location
				player_inventory.remove_item(item)
				player_inventory.add_item(ItemManager.get_item_by_name("blood"), item_coords)
				break
		entity_node.clear_self()
 
func burn(entity_node:Entity) -> void:
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer") 
	var player_inventory: Inventory = inventory_manager.player_inventory
	if player_inventory.items:
		for item in player_inventory.items.get_children():
			if item.data.name == "torch":
				player_inventory.remove_item(item)
		inventory_manager.display_hidden_inventory_with_items(treasure)
		entity_node.clear_self()

func fight(entity_node:Entity) -> void:
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats[Enums.stats.power], threshold)
	if not pass_check:
		character.take_damage(damage)
	entity_node.clear_self()
