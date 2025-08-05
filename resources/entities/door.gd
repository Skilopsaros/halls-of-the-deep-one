extends EntityData
class_name EntityDoorData

#self.skin = load("res://graphics/entities/door.png")

var choices: Array[Dictionary] = [
	{
		"title": "Move forward",
		"text": "Go to the next room",
		"action": next_room
	}
]

func next_room(entity_node:Entity):
	entity_node.get_node("/root/Main").init_next_room()
	entity_node.clear_self()
