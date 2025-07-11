extends GridContainer

@export var ItemSlotBG: PackedScene

#var item_slots = []

func display_item_slots(rows,cols,occupancy):
	columns = cols
	var slots = rows*cols
	for index in range(slots):
		var item_slot = ItemSlotBG.instantiate()
		if occupancy[index] == 0:
			item_slot.color = Color("4a2350")
		else:
			item_slot.color = Color("daa95e")
		add_child(item_slot)

func update_item_slots(occupancy):
	var item_slots = get_children()
	for index in range(len(occupancy)):
		if occupancy[index] == 1:
			item_slots[index].color = Color("daa95e")
		else:
			item_slots[index].color = Color("4a2350")
			
