extends EntityData
class_name Statue

@export var skin: Texture = load("res://graphics/entities/statue.png")
var second_skin: Texture = load("res://graphics/entities/wizard.png")
@export var insanity: int = 5
@export var attack_threshold: int = 12
@export var damage: int = 10
@export var threshold = 12
@export var inv_size: Vector2i = Vector2i(2,1)
@export var inv_items: Dictionary[String, int] = {"metal_ingot":0}
@export var gift_size: Vector2i = Vector2i(2,1)
@export var gift_items: Dictionary[String, int] = {"magic_ingot":0}
@export var loot_size: Vector2i = Vector2i(1,4)
@export var loot_items: Dictionary[String, int] = {"staff":0}
@export var attack_size: Vector2i = Vector2i(4,4)
@export var attack_items: Dictionary[String, int] = {"staff":0, "magic_ingot":1}

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Investigate",
			"text": "Attempt to find the hidden compartment. Perception check ("+str(threshold)+").",
			"action": investigate
		},
		{
			"title": "Loot",
			"text": "Steal the statue's staff. Gain " + str(insanity) + " insanity",
			"action": loot
		},
		{
			"title": "Use strange Brew",
			"text": "Use the strange brew on the statue",
			"action": use_strange_brew,
			"requirement":requirement_strange_brew
		}
	]
	return(choices)

func requirement_strange_brew(entity_node:Entity):
	var player_inventory: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_inventory
	for item in player_inventory.items.values():
		if item.name == "strange_brew":
			return(true)
	return(false)

func use_strange_brew(entity_node:Entity):
	var choices: Array[Dictionary] = [
		{
			"title": "Attack",
			"text": "Power check ("+str(threshold)+"). On success, take "+str(damage)+" damage and all the wizard's stuff. On failure take double damage.",
			"action": attack
		},
		{
			"title": "Accept Gift",
			"text": "Take the magical ingot that the wizard offers you",
			"action": gift
		},
		{
			"title": "Accept Boon",
			"text": "Raise all stats by 2",
			"action": boon
		}
	]
	entity_node.get_node("/root/Main/ChoisesContainer").add_options_from_options_list(choices, entity_node)
	entity_node.sprite.texture = second_skin
	

func investigate(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats[Enums.stats.perception], threshold)
	if pass_check:
		var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
		var chest := inventory_manager.add_inventory(inv_size.x,inv_size.y,"Chest")
		for item in inv_items:
			chest.add_item(ItemManager.get_item_by_name(item), inv_items[item])
	entity_node.clear_self()

func loot(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	character.take_insanity(insanity)
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
	var chest := inventory_manager.add_inventory(loot_size.x,loot_size.y,"Chest")
	for item in loot_items:
		chest.add_item(ItemManager.get_item_by_name(item), loot_items[item])
	entity_node.clear_self()

func gift(entity_node:Entity):
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
	var chest := inventory_manager.add_inventory(gift_size.x,gift_size.y,"Chest")
	for item in gift_items:
		chest.add_item(ItemManager.get_item_by_name(item), gift_items[item])
	entity_node.clear_self()

func boon(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	for stat in character.stats:
		character.change_stat(stat, 2)
	entity_node.clear_self()

func attack(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats[Enums.stats.power], threshold)
	character.take_damage(damage)
	if pass_check:
		var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
		var chest := inventory_manager.add_inventory(attack_size.x,attack_size.y,"Chest")
		for item in attack_items:
			chest.add_item(ItemManager.get_item_by_name(item), attack_items[item])
	else: 
		character.take_damge(damage)
	entity_node.clear_self()
 
