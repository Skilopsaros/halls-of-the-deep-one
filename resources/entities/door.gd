extends EntityData
class_name Door


@export var skin: Texture = load("res://graphics/entities/door.png")

func get_choices() -> Array[Dictionary]:
	var choices: Array[Dictionary] = [
		{
			"title": "Move forward",
			"text": "Go to the next room",
			"action": next_room
		}
	]
	return(choices)

func next_room(entity_node:Entity):
	var character = entity_node.get_node("/root/Main/PlayerHud").character
	var player_inventory: Inventory = entity_node.get_node("/root/Main/InventoryLayer").player_inventory
	if player_inventory.items:
		for item_key in player_inventory.items.keys():
			if Enums.item_tags.liquid in player_inventory.items[item_key].tags:
				character.take_insanity(1)
	entity_node.get_node("/root/Main").init_next_room()
	entity_node.clear_self()
