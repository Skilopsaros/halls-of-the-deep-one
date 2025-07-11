extends Node

@onready var foreground = $inventory_foreground
@onready var background = $inventory_background

@export var cols = 9
@export var rows = 3
var slots
var items = []
var occupancy = [] # this really doesn't need to be an array, it only contains singe bits
# TODO for the future: refactor this to be a binary number with 1 bit per slot
# also makes the add_item function be able to use bitwise comparisons instead of loops for 
# incredible performance

func _ready():
	slots = cols * rows
	for i in range(slots):
		items.append({})
		occupancy.append(0)

	background.display_item_slots(rows,cols,occupancy)
	foreground.display_item_slots(rows,cols,items)

func update_item_slots():
	background.update_item_slots(occupancy)
	foreground.update_item_slots(items)

func _calculate_reshaped_occupancy(item):
	var bounding_box = item.bounding_box
	var occupied_spaces = item.occupied_spaces
	var reshaped_occupied_spaces = []
	var buffer_length = cols - bounding_box[1]
	var buffer = []
	buffer.resize(buffer_length)
	buffer.fill(0)
	for row in occupied_spaces:
		reshaped_occupied_spaces.append_array(row) # using array.resize and then assigning would be more performant probably
		# now 0 buffers
		reshaped_occupied_spaces.append_array(buffer)
	reshaped_occupied_spaces.reverse() # it's not pretty but it works.....
	for i in range(buffer_length):
		reshaped_occupied_spaces.remove_at(0)
	reshaped_occupied_spaces.reverse()
	return reshaped_occupied_spaces

func set_item(item,position):
	var reshaped_occupancy = _calculate_reshaped_occupancy(item)
	# attempt to put the item in
	for i in range(len(reshaped_occupancy)):
		if occupancy[i+position] + reshaped_occupancy[i] >= 2:
			return false
	for i in range(len(reshaped_occupancy)):
		if reshaped_occupancy[i] >= 1:
			occupancy[i+position] = reshaped_occupancy[i]
	items[position] = item
	update_item_slots()
	return true

func remove_item(position):
	var item = items[position].duplicate()
	var reshaped_occupancy = _calculate_reshaped_occupancy(item)
	items[position].clear()
	for i in range(len(reshaped_occupancy)):
		if reshaped_occupancy[i] >= 1:
			occupancy[i+position] = 0
	return item
