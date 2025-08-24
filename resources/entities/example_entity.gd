extends EntityData
class_name EntityExampleEntityData

@export var skin: Texture = load("res://graphics/entities/master_poisoner.png")
@export var damage: int = 2
@export var insanity: int = 2
@export var sneak_threshold: int = 6

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Lose Health",
			"text": "Lose " + str(damage) + " health",
			"action": lose_health
		},
		{
			"title": "Gain Insanity",
			"text": "Gain " + str(insanity) + " insanity",
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
	if character.stats[Enums.stats.agility] > sneak_threshold:
		return(true)
	return(false)

func sneak_by(entity_node:Entity):
	entity_node.clear_self()

func lose_health(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	character.take_damage(damage)
	entity_node.clear_self()

func gain_insanity(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	character.take_insanity(insanity)
	entity_node.clear_self()
 
