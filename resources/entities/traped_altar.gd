extends EntityData
class_name TrapedAltar

@export var skin: Texture = load("res://graphics/entities/master_poisoner.png")
var second_skin: Texture = load("res://graphics/entities/master_poisoner.png")
@export var damage: int = 15
@export var threshold: int = 13
@export var pow_loss: int = 1

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Take Treasure",
			"text": "The loot is obviously trapped. Take it, but suffer the consequences...",
			"action": take_treasure
		},
		{
			"title": "Disarm",
			"text": "Perception check ("+str(threshold)+"). On success, skip the trap. On failure, take " + str(damage) + " damage.",
			"action": disarm
		},
		{
			"title": "Ignore",
			"text": "Move on. Not worth it.",
			"action": ignore
		}
	]
	return(choices)

func ignore(entity_node:Entity) -> void:
	entity_node.clear_self()
	
func disarm(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats[Enums.stats.perception], threshold)
	if not pass_check:
		character.take_damage(damage)
	else:
		give_treasure(entity_node)

func take_treasure(entity_node:Entity):
	var choices: Array[Dictionary] = [
		{
			"title": "Brave the damage",
			"text": "Take " + str(damage) + " damage.",
			"action": take_damage
		},
		{
			"title": "Hold the trap open",
			"text": "Lose " + str(pow_loss) + " Power.",
			"action": lose_power
		},
		{
			"title": "Block it with Armour",
			"text": "The armour might not survive, but you will.",
			"action": destroy_armour,
			"requirement": wearing_armour
		}
	]
	entity_node.get_node("/root/Main/ChoisesContainer").add_options_from_options_list(choices, entity_node)
	entity_node.sprite.texture = second_skin
	
func wearing_armour(entity_node:Entity):
	var player_armour: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_armour
	for item in player_armour.items.get_children():
		if item.data.name in ["chain_mail", "heavy_armour", "enchanted_armour"]:
			return(true)
	return(false)

func give_treasure(entity_node:Entity):
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
	inventory_manager.display_hidden_inventory_with_items(["gem"])
	entity_node.clear_self()

func take_damage(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	character.take_damage(damage)
	give_treasure(entity_node)
	
func lose_power(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	character.change_Stat(Enums.stats.power, -pow_loss)
	give_treasure(entity_node)

func destroy_armour(entity_node:Entity):
	var player_armour: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_armour
	for item in player_armour.items.get_children():
		if item.data.name == "chain_mail":
			player_armour.remove_item(item)
			give_treasure(entity_node)
			break
		if item.data.name == "heavy_armour":
			var item_coords: Vector2i = item.location
			player_armour.remove_item(item)
			player_armour.add_item(ItemManager.get_item_by_name("broken_armour"), item_coords)
			give_treasure(entity_node)
			break
		if item.data.name == "enchanted_armour":
			give_treasure(entity_node)
			break
			
