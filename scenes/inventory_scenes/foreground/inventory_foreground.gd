extends GridContainer

@export var ItemSlot: PackedScene

func display_item_slots(rows,cols,items):
	var slots = cols*rows
	columns = cols
	for index in range(slots):
		var item_slot = ItemSlot.instantiate()
		add_child(item_slot)
		item_slot.display_item(items[index])

func update_item_slots(items):
	var item_slots = get_children()
	for index in range(len(items)):
		item_slots[index].display_item(items[index])
