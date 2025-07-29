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
		item_slot.background.color = Color("4a2350")
		item_slot.display_item(null)
	item_slots = get_children()

func update_item_slots(items: Dictionary) -> void:
	for index in items.keys():
		var item:Item = items[index]
		item_slots[index].display_item(item)

func update_occupancy(occupancy: Array) -> void:
	for index in range(len(occupancy)):
		if occupancy[index] == 1:
			item_slots[index].texture = active_texture
			item_slots[index].background.color = Color("daa95e")
		else:
			item_slots[index].texture = inactive_texture
			item_slots[index].background.color = Color("4a2350")

func add_item(index: int,item: Item) -> void:
	item_slots[index].display_item(item)
	
func remove_item(index: int) -> void:
	item_slots[index].display_item(null)
