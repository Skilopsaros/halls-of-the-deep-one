extends EntityData
class_name Snake

@export var skin: Texture = load("res://graphics/entities/snake.png")
@export var damage: int = 10
@export var pow_loss: int = -2
@export var threshold: int = 10

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Slay",
			"text": "Take " + str(damage) + " - POW damage",
			"action": lose_health
		},
		{
			"title": "Avoid Bite",
			"text": "Agility check ("+str(threshold)+"). On success, skip the monster. On failure, lose " + str(pow_loss) + " Power.",
			"action": avoid_bite
		}
	]
	return(choices)

func avoid_bite(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats[Enums.stats.agility], threshold)
	if not pass_check:
		character.change_stat(Enums.stats.power, pow_loss)
	entity_node.clear_self()

func lose_health(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	character.take_damage(damage - character.stats[Enums.stats.power])
	entity_node.clear_self()
 
