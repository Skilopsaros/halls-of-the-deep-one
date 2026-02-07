extends EntityData
class_name Acolyte

@export var skin: Texture = load("res://graphics/entities/master_poisoner.png")
@export var threshold: int = 10
@export var insanity: int = 10

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Slay",
			"text": "Agility check (" + str(threshold) + ") on failure take " + str(insanity) + " insanity",
			"action": slay
		},
		{
			"title": "Listen",
			"text": "Take " + str(insanity) + " - PRC insanity",
			"action": listen
		}
	]
	return(choices)

func slay(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats[Enums.stats.agility], threshold)
	if not pass_check:
		character.take_insanity(insanity)
	entity_node.clear_self()

func listen(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	character.take_insanity(insanity-character.stats[Enums.stats.perception])
	entity_node.clear_self()
