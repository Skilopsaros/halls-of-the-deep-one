extends EntityData
class_name Scales

@export var skin: Texture = load("res://graphics/entities/master_poisoner.png")
@export var damage: int = 2
@export var insanity: int = 2
@export var sneak_threshold: int = 6
var all_stats = [Enums.stats.perception, Enums.stats.occult, Enums.stats.agility, Enums.stats.power]
var stat_names: Dictionary[Enums.stats, String] = {
	Enums.stats.perception:"perception",
	Enums.stats.agility:"agility",
	Enums.stats.occult:"occult",
	Enums.stats.power:"power"
}

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Small Trade",
			"text": "Lose 1 " + stat_names[all_stats[0]] + ", gain 1 "+ stat_names[all_stats[1]],
			"action": small_trade
		},
		{
			"title": "Average Trade",
			"text": "Lose 2 " + stat_names[all_stats[2]] + ", gain 2 "+ stat_names[all_stats[3]],
			"action": average_trade
		},
		{
			"title": "Large Trade",
			"text": "Lose 3 " + stat_names[all_stats[1]] + ", gain 3 "+ stat_names[all_stats[2]],
			"action": large_trade
		}
	]
	return(choices)

func small_trade(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	trade(character,all_stats[0], all_stats[1], 1)
	entity_node.clear_self()

func average_trade(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	trade(character,all_stats[2], all_stats[3], 2)
	entity_node.clear_self()

func large_trade(entity_node:Entity):
	var character: Character = entity_node.get_node("/root/Main/PlayerHud").character
	trade(character,all_stats[1], all_stats[2], 3)
	entity_node.clear_self()

func trade(character:Character, stat_to_lose:Enums.stats, stat_to_gain:Enums.stats, amount:int):
	character.change_stat(stat_to_lose, -amount)
	character.change_stat(stat_to_gain, amount)

func randomise(_level_data):
	all_stats.shuffle()
