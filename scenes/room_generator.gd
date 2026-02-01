extends Node
class_name RoomGenerator

func loot_table_to_array(loot_table:Dictionary[String,int]) -> Array[String]:
	var loot_array:Array[String] = []
	for key in loot_table:
		for i in range(loot_table[key]):
			loot_array.append(key)
	return(loot_array)
		

func make_room(level:LevelData):
	var n_stacks: int = randi_range(3,4)
	var door_room: int = randi_range(0,n_stacks-1)
	var my_room_data: RoomData = RoomData.new()
	my_room_data.room_art = level.room_art
	for i in range(n_stacks):
		var my_enity_stack:EntityStack = EntityStack.new()
		var monster_entity = level.monsters[randi() % level.monsters.size()].new()
		my_enity_stack.entities.append(monster_entity)
		var curio_entity = level.curios[randi() % level.curios.size()].new()
		my_enity_stack.entities.append(curio_entity)
		if i == door_room:
			my_enity_stack.entities.append(Door.new())
		else:
			var treasure_entity = level.treasure[randi() % level.treasure.size()].new()
			treasure_entity.randomise(level)
			my_enity_stack.entities.append(treasure_entity)
		my_room_data.entities.append(my_enity_stack)
	return(my_room_data)
