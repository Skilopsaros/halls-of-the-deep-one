extends EntityData
class_name Chest

@export var skin: Texture = load("res://graphics/entities/chest.png")
@export var items: Array[String] = ["silver_coin", "copper_coin", "empty_bottle"]
@export var trapped: bool = false
@export var damage: int = 15
@export var threshold: int = 15
@export var disarm_threshold: int = 15
@export var insanity: int = 4
@export var detected_damage: int = 10
var detected: bool = false

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
			{
				"title": "Check for traps",
				"text": "Perception check ({0}). On success, reveal if chest is trapped. On failure, take {1} insanity.".format([str(threshold), str(insanity)]),
				"action": check_for_traps
			},
			{
				"title": "Open chest",
				"text": "Open the chest. If the chest is trapped take {0}-agility damage".format([str(damage)]),
				"action": open_chest
			},
			{
				"title": "Ignore",
				"text": "Ignore the chest. Do not open",
				"action": ignore
			}
		]
	return(choices)

func ignore(entity_node:Entity) -> void:
	entity_node.clear_self()

func check_for_traps(entity_node:Entity) -> void:
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats[Enums.stats.perception], threshold)
	if pass_check:
		detected = true
		var choices: Array[Dictionary]
		if trapped:
			choices = [
				{
					"title": "Open trapped chest",
					"text": "Take {0}-Agility Damage, then open the chest".format([str(detected_damage)]),
					"action": open_chest
				},
				{
					"title": "Disarm traps",
					"text":  "Agility check ({0}). On success, open the chest. On failure, take {1}-power damage.".format([str(disarm_threshold), str(damage)]),
					"action": disarm_traps
				},
				{
					"title": "Ignore",
					"text": "Ignore the chest. Do not open",
					"action": ignore
				}
			]
		else:
			choices = [
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

func disarm_traps(entity_node:Entity) -> void:
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats[Enums.stats.agility], disarm_threshold)
	if not pass_check:
		character.take_damage(damage-character.stats[Enums.stats.power])
	trapped = false
	open_chest(entity_node)
	pass

func open_chest(entity_node:Entity) -> void:
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	if trapped:
		if detected:
			character.take_damage(detected_damage-character.stats[Enums.stats.agility])
		else:
			character.take_damage(damage-character.stats[Enums.stats.agility])
	var inventory_manager: InventoryManager = entity_node.get_node("/root/Main/InventoryLayer")
	inventory_manager.display_hidden_inventory_with_items(items)
	entity_node.clear_self()

func randomise(loot_table):
	print("here")
	loot_table.shuffle()
	items = []
	for i in range(randi_range(3,6)):
		if len(loot_table) > i:
			items.append(loot_table[i])
	print(items)
