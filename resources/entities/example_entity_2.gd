extends EntityData
class_name EntityExampleEntityTwoData

@export var skin: Texture = load("res://graphics/entities/master_poisoner_advanced.png")

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Lose Health",
			"text": "Lose 3 health",
			"action": lose_health
		},
		{
			"title": "Gain Insanity",
			"text": "Gain 3 insanity",
			"action": gain_insanity
		},
		{
			"title": "Sneak by",
			"text": "skip this monster",
			"action": sneak_by,
			"requirement":requirement_to_skip
		}
	]
	return(choices)

func requirement_to_skip(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	if character.stats["agility"]  > 14:
		return(true)
	return(false)

func sneak_by(entity_node:Entity):
	entity_node.clear_self()


func lose_health(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	character.take_damage(3)
	entity_node.clear_self()

func gain_insanity(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	character.take_insanity(3)
	entity_node.clear_self()
