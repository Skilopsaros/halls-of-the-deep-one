extends Entity

func _ready() -> void:
	self.skin = load("res://graphics/entities/chest.png")
	super._ready()
	choices = [
		{
			"title": "Check for traps",
			"text": "Perception check (17). On success, reveal if chest is trapped. On failure, take 4 insanity.",
			"action": check_for_traps
		},
		{
			"title": "Open chest",
			"text": "Open the chest. If the chest is trapped take 20-agility damage",
			"action": open_chest
		},
		{
			"title": "Ignore",
			"text": "Ignore the chest. Do not open",
			"action": ignore
		}
	]

func ignore():
	clear_self()

func check_for_traps():
	var character: Character = get_node("/root/Main/PlayerHud").character
	var pass_check: bool = await get_node("/root/Main").roll_dice(character.stats["perception"], 17)
	if pass_check:
		choices = [
			{
				"title": "Open chest",
				"text": "Open the chest",
				"action": open_chest
			},
			{
				"title": "Ignore",
				"text": "Ignore the chest. Do not open",
				"action": ignore
			}
		]
		get_node("/root/Main/ChoisesContainer").add_options_from_options_list(choices)
	else:
		character.take_insanity(4)
		

func open_chest():
	print("open")
	clear_self()
