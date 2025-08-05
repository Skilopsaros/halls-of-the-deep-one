extends EntityData
class_name EntityExampleEntityData


#self.skin = load("res://graphics/entities/master_poisoner.png")

var choices: Array[Dictionary] = [
	{
		"title": "Lose Health",
		"text": "Lose 2 health",
		"action": lose_health
	},
	{
		"title": "Gain Insanity",
		"text": "Gain 2 insanity",
		"action": gain_insanity
	},
	{
		"title": "Sneak by",
		"text": "skip this monster",
		"action": sneak_by,
		"requirement":requirement_to_skip
	}
]

func requirement_to_skip(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	if character.stats["agility"] > 6:
		return(true)
	return(false)

func sneak_by(entity_node:Entity):
	entity_node.clear_self()

func lose_health(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	character.take_damage(2)
	entity_node.clear_self()

func gain_insanity(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	character.take_insanity(2)
	entity_node.clear_self()
