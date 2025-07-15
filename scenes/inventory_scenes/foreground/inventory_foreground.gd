extends GridContainer

@export var ItemSlot: PackedScene

func initialize_item_slots(rows,cols) -> void:
	var slots:int = cols*rows
	columns = cols
	for index in range(slots):
		var item_slot := ItemSlot.instantiate()
		add_child(item_slot)
		item_slot.background.color = Color("4a2350")
		item_slot.display_item({})

func update_item_slots(items) -> void:
	var item_slots := get_children()
	for index in items.keys():
		var item:Dictionary = items[index]
		item_slots[index].display_item(item)

func update_occupancy(occupancy) -> void:
	var item_slots := get_children()
	for index in range(len(occupancy)):
		if occupancy[index] == 1:
			item_slots[index].background.color = Color("daa95e")
		else:
			item_slots[index].background.color = Color("4a2350")

func add_item(index,item) -> void:
	var item_slots := get_children()
	item_slots[index].display_item(item)
	
func remove_item(index) -> void:
	var item_slots := get_children()
	item_slots[index].display_item({})
