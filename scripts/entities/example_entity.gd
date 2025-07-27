extends Entity

func _ready() -> void:
	self.skin = load("res://graphics/entities/master_poisoner.png")
	super._ready()
	choices = [
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

func requirement_to_skip():
	var character = get_node("/root/Main/PlayerHud").character
	if character.stats["agility"] > 6:
		return(true)
	return(false)

func sneak_by():
	clear_self()

func lose_health():
	var character = get_node("/root/Main/PlayerHud").character
	character.take_damage(2)
	clear_self()

func gain_insanity():
	var character = get_node("/root/Main/PlayerHud").character
	character.take_insanity(2)
	clear_self()
