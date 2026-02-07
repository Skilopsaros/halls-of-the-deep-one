extends EntityData
class_name EldritchAltar

@export var skin: Texture = load("res://graphics/entities/master_poisoner.png")
@export var threshold: int = 12
@export var insanity: int = 5
@export var damage: int = 5
@export var sneak_threshold: int = 6

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Break Altar",
			"text": "Brawn check (" + str(threshold) + ") to gain what is at the altar's core. Gain " + str(insanity) + " insanity.",
			"action": break_altar
		},
		{
			"title": "Pray",
			"text": "Occult check (" + str(threshold) + "). Lose " + str(insanity) + " insanity on success, but on failure take " + str(damage) + " damage.",
			"action": pray
		},
		{
			"title": "Burn",
			"text": "Use a torch. The eye of the Deep one will not look kindly upon you.",
			"action": burn,
			"requirement":requirement_torch
		},
		{
			"title": "Fill the cup",
			"text": "The inscription calls for blood, but any liquid might do.",
			"action": fill_cup
		}
	]
	return(choices)

func requirement_torch(entity_node:Entity):
	var player_inventory: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_inventory
	for item in player_inventory.items.get_children():
		if item.data.name == "torch":
			return(true)
	return(false)

func fill_cup(entity_node:Entity):
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
	var altar_inventory := inventory_manager.show_input_inventory(4,4,{},[Enums.item_tags.liquid],"Add a Liquid")
	altar_inventory.connect("inventory_hiding", fill_cup_after_closed_inventory.bind(entity_node))
	
func fill_cup_after_closed_inventory(inventory:Inventory, entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
	if inventory.items:
		var items: Array[String] = ["empty_bottle"]
		for item in inventory.items.get_children():
			if item.data.name == "strange_brew":
				items.append("suspicious_eyeball")
			if item.data.name == "blood":
				character.heal_damage(damage)
				character.take_insanity(insanity)
			if item.data.name == "acid":
				character.take_damage(damage)
				character.heal_insanity(insanity)
			if item.data.name == "ectoplasm":
				pass # give inventory space
		inventory_manager.display_hidden_inventory_with_items(items)
		entity_node.clear_self()

func break_altar(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats[Enums.stats.power], threshold)
	if pass_check:
		var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
		inventory_manager.display_hidden_inventory_with_items(["gem"])
	else:
		character.take_insanity(insanity)
	entity_node.clear_self()

func pray(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats[Enums.stats.occult], threshold)
	if pass_check:
		character.heal_insanity(insanity)
	else:
		character.take_damage(damage)
	entity_node.clear_self()
	
func burn(entity_node:Entity):
	# Add Deep one anger
	var player_inventory: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_inventory
	if player_inventory.items:
		for item_key in player_inventory.items.get_children():
			if player_inventory.items.data.name == "torch":
				break
		entity_node.clear_self()
 
