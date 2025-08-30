extends GridContainer

@onready var inactive_texture = load("res://graphics/inventory/inventory_1_maps/inventory_slot.tres")
@onready var active_texture = load("res://graphics/inventory/inventory_1_maps/inventory_slot_active.tres")

@export var ItemSlot: PackedScene
var item_slots: Array[Node]

func initialize_item_slots(rows: int,cols: int) -> void:
	var slots:int = cols*rows
	columns = cols
	for index in range(slots):
		var item_slot := ItemSlot.instantiate()
		add_child(item_slot)
		item_slot.texture = inactive_texture
		item_slot.display_item(null)
	item_slots = get_children()

func reshape(rows: int, cols: int) -> void:
	var slots:int = cols*rows
	columns = cols
	if len(item_slots) < slots:
		for index in range(slots-len(item_slots)):
			var item_slot := ItemSlot.instantiate()
			add_child(item_slot)
			item_slot.texture = inactive_texture
			item_slot.display_item(null)
			item_slots.append(item_slot)
	else:
		var removal_index_array:Array = range(slots,len(item_slots))
		removal_index_array.reverse()
		for index in removal_index_array:
			var to_remove := item_slots[index]
			item_slots.remove_at(index)
			to_remove.queue_free()
	
func update_item_slots(items: Dictionary) -> void:
	for index in items.keys():
		var item:Item = items[index]
		item_slots[index].display_item(item)

func update_occupancy(occupancy: Array) -> void:
	for index in range(len(occupancy)):
		if occupancy[index] == 1:
			item_slots[index].texture = active_texture
		else:
			item_slots[index].texture = inactive_texture

func add_item(index: int,item: Item) -> void:
	item_slots[index].display_item(item)
	
func remove_item(index: int) -> void:
	item_slots[index].display_item(null)
