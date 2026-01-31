extends Node
class_name RoomGenerator

var level_1_curios:Array = [
	AlchemyTable,
	Scales
]

var level_1_treasure:Array  = [
	Chest
]

var level_1_monsters:Array  = [
	GiantRat,
	Ghost
]

var level_1_loot_table:Dictionary[String,int] = {
	"gold_coin":2,
	"silver_coin":4,
	"copper_coin":6,
	"amulet":1,
	"empty_bottle":3,
	"metal_ingot":2,
	"magic_ingot":1,
	"gem":1,
	"shoe":1,
	"torch":2
}

func loot_table_to_array(loot_table:Dictionary[String,int]) -> Array[String]:
	var loot_array:Array[String] = []
	for key in loot_table:
		for i in range(loot_table[key]):
			loot_array.append(key)
	return(loot_array)
		

func make_level_1_room():
	var my_room_data = RoomData.new()
	for i in range(4):
		var my_enity_stack:EntityStack = EntityStack.new()
		my_enity_stack.entities.append(level_1_monsters[randi() % level_1_monsters.size()].new())
		my_enity_stack.entities.append(level_1_curios[randi() % level_1_curios.size()].new())
		if i == 0:
			my_enity_stack.entities.append(Door.new())
		else:
			var new_entity = level_1_treasure[randi() % level_1_treasure.size()].new()
			new_entity.randomise(loot_table_to_array(level_1_loot_table))
			my_enity_stack.entities.append(new_entity)
		my_room_data.entities.append(my_enity_stack)
	return(my_room_data)
