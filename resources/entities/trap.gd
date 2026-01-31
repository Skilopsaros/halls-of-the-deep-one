extends EntityData
class_name Trap

@export var skin: Texture = load("res://graphics/entities/master_poisoner.png")
@export var damage: int = 10
@export var threshold: int = 10

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Avoid",
			"text": "Take " + str(damage) + " - AGL damage",
			"action": lose_health
		},
		{
			"title": "Disarm",
			"text": "Perception check ("+str(threshold)+"). On success, skip the trap. On failure, take " + str(damage) + " damage.",
			"action": disarm
		}
	]
	return(choices)

func disarm(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats[Enums.stats.perception], threshold)
	if not pass_check:
		character.take_damage(damage)
	entity_node.clear_self()

func lose_health(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	character.take_damage(damage - character.stats[Enums.stats.agility])
	entity_node.clear_self()
 
