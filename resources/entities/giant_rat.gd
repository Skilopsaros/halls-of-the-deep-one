extends EntityData
class_name GiantRat

@export var skin: Texture = load("res://graphics/entities/rat.png")
@export var damage: int = 10
@export var threshold: int = 10

func get_choices() -> Array[Dictionary]:   
	var choices: Array[Dictionary] = [
		{
			"title": "Fight",
			"text": "Take " + str(damage) + " - POW damage",
			"action": lose_health
		},
		{
			"title": "Outrun",
			"text": "Agility check ("+str(threshold)+"). On success, skip the monster. On failure, take " + str(damage) + " damage.",
			"action": outrun
		}
	]
	return(choices)

func outrun(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await entity_node.get_node("/root/Main").roll_dice(character.stats[Enums.stats.agility], threshold)
	if not pass_check:
		character.take_damage(damage)
	entity_node.clear_self()

func lose_health(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	character.take_damage(damage - character.stats[Enums.stats.power])
	entity_node.clear_self()
 
