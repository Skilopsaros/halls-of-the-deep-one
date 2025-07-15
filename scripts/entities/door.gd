extends Entity

func _ready() -> void:
	self.skin = load("res://graphics/entities/door.png")
	super._ready()
	choices = [
		{
			"title": "Move forward",
			"text": "Go to the next room",
			"action": next_room
		}
	]

func next_room():
	get_node("/root/Main").init_next_room()
	clear_self()
