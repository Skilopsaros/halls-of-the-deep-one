extends EntityData
class_name SwordInStone

@export var skin: Texture = load("res://graphics/entities/sword_in_stone.png")
var second_skin: Texture = load("res://graphics/entities/sword_monster.png")
@export var threshold: int = 15
@export var damage: int = 10
@export var damage_increase: int = 15
@export var inv_size: Vector2i = Vector2i(4,1)
@export var broken_sword: Dictionary[String, int] = {"broken_sword":0}
@export var sword: Dictionary[String, int] = {"epic_sword":0}

@export var attack_damage: int = 15
@export var consume_insanity: int = 5
@export var consume_occult_loss: int = 5


func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Pull the sword out",
			"text": "Strength check (" + str(threshold) + "but take " + str(damage) + " on failure. May be retried but the damage will increase by" + str(damage_increase) + " each time.",
			"action": pull_sword
		},
		{
			"title": "Break the sword",
			"text": "Even just the hilt may be useful",
			"action": break_sword
		},
		{
			"title": "Use strange brew",
			"text": "The strange brew might have an effect on the stone",
			"action": use_strange_brew,
			"requirement": requirement_strange_brew
		}
	]
	return(choices)

func requirement_strange_brew(entity_node:Entity):
	var player_inventory: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_inventory
	for item in player_inventory.items.values():
		if item.name == "strange_brew":
			return(true)
	return(false)

func break_sword(entity_node:Entity):
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
	var chest := inventory_manager.add_inventory(inv_size.x,inv_size.y,"Stone")
	for item in broken_sword:
		chest.add_item(ItemManager.get_item_by_name(item), broken_sword[item])
	entity_node.clear_self()

func pull_sword(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats[Enums.stats.power], threshold)
	if pass_check:
		give_sword(entity_node)

func use_strange_brew(entity_node:Entity):
	var choices: Array[Dictionary] = [
		{
			"title": "Fight",
			"text": "Take "+str(attack_damage)+"-Pow damage, take the sword",
			"action": attack
		},
		{
			"title": "Consume",
			"text": "Take " +str(consume_insanity)+" insanity and lose "+str(consume_occult_loss)+" Occult. Take the sword",
			"action": consume
		},
		{
			"title": "Avoid",
			"text": "Agility check ("+str(threshold)+"). On failure take "+str(attack_damage)+" damage.",
			"action": avoid
		}
	]
	entity_node.get_node("/root/Main/ChoisesContainer").add_options_from_options_list(choices, entity_node)
	entity_node.sprite.texture = second_skin

func attack(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	character.take_damage(attack_damage-character.stats[Enums.stats.power])
	give_sword(entity_node)
	entity_node.clear_self()

func consume(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	character.take_insanity(consume_insanity)
	character.change_stats(Enums.stats.occult, -1)
	give_sword(entity_node)
	entity_node.clear_self()

func avoid(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats[Enums.stats.agility], threshold)
	if not pass_check:
		character.take_damage(attack_damage)
	entity_node.clear_self()

func give_sword(entity_node:Entity):
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
	var chest := inventory_manager.add_inventory(inv_size.x,inv_size.y,"Stone")
	for item in sword:
		chest.add_item(ItemManager.get_item_by_name(item), sword[item])
