extends Resource
class_name EntityData

func get_choices() -> Array[Dictionary]:
	return([])

func loot_table_to_array(loot_table:Dictionary[String,int]) -> Array[String]:
	var loot_array:Array[String] = []
	for key in loot_table:
		for i in range(loot_table[key]):
			loot_array.append(key)
	return(loot_array)

func randomise(_level_data):
	pass
