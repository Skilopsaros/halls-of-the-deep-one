extends EntityData
class_name EntityChestData

@export var test: String = "hello"

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
			{
				"title": "Check for traps",
				"text": "Perception check (17). On success, reveal if chest is trapped. On failure, take 4 insanity.",
				"action": check_for_traps
			},
			{
				"title": "Open chest",
				"text": "Open the chest. If the chest is trapped take 20-agility damage",
				"action": open_chest
			},
			{
				"title": "Ignore",
				"text": "Ignore the chest. Do not open",
				"action": ignore
			}
		]
	return(choices)

func ignore(entity_node:Entity):
	entity_node.clear_self()

func check_for_traps(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats["perception"], 17)
	if pass_check:
		var choices: Array[Dictionary] = [
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
		

func open_chest(entity_node:Entity):
	print("open")
	entity_node.clear_self()
