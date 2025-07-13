extends GridContainer

@export var ItemSlotBG: PackedScene

func initialize_item_slots(rows,cols):
	columns = cols
	var slots = rows*cols
	for index in range(slots):
		var item_slot = ItemSlotBG.instantiate()
		item_slot.get_children()[0].color = Color("4a2350")
		add_child(item_slot)

func update_item_slots(occupancy):
	var item_slots = get_children()
	for index in range(len(occupancy)):
		if occupancy[index] == 1:
			item_slots[index].get_children()[0].color = Color("daa95e")
		else:
			item_slots[index].get_children()[0].color = Color("4a2350")
			
