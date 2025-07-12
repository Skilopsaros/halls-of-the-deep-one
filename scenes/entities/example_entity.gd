extends Entity

func _ready() -> void:
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
		}
	]

func lose_health():
	var character = get_node("/root/Main/PlayerHud").character
	character.take_damage(2)

func gain_insanity():
	var character = get_node("/root/Main/PlayerHud").character
	character.take_insanity(2)
