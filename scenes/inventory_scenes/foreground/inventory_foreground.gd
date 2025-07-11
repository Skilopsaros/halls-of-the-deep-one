extends GridContainer

@export var ItemSlot: PackedScene

func initialize_item_slots(rows,cols):
	var slots = cols*rows
	columns = cols
	for index in range(slots):
		var item_slot = ItemSlot.instantiate()
		add_child(item_slot)
		item_slot.display_item({})

func update_item_slots(items):
	var item_slots = get_children()
	for item in items:
		var index = item[0]
		var item_object = item[1]
		item_slots[index].display_item(item_object)
