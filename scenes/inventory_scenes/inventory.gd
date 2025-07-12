extends Node2D

@onready var foreground := $inventory_foreground
@onready var background := $inventory_background
@onready var background_rect := $background_rect # TODO make bigger on top and make the whole thing draggable

@export var cols:int = 9
@export var rows:int = 3
var slots:int
var items = [] # this will be a list of tuples [position,item]
# current problem: showing two items with the bounding box at the same top left corner not possible
var occupancy = [] # 0 if no item, 1 if item
var occupancy_pters = [] # has the same shape as occupancy, but contains pointers to the item that occupies a certain space

func _ready():
	slots = cols * rows
	for i in range(slots):
		occupancy.append(0)
		occupancy_pters.append(null)
	
	var background_width = cols*60+10
	var background_height = rows*60+10
	background_rect.size = Vector2(background_width,background_height)
	background.initialize_item_slots(rows,cols)
	foreground.initialize_item_slots(rows,cols)
	position = Vector2(get_viewport().size/2)-Vector2(background_width/2,background_height/2)

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
	# number one: does the bounding box fit
	var bounding_box = item.bounding_box
	if (position%cols - item.offset + bounding_box[1]) > cols:
		return false
	if (int(position/cols)) + bounding_box[0] > rows:
		return false
	
	for i in range(len(reshaped_occupancy)):
		if occupancy[i+position-item.offset] + reshaped_occupancy[i] >= 2:
			return false
	for i in range(len(reshaped_occupancy)):
		if reshaped_occupancy[i] >= 1:
			if reshaped_occupancy[i] == 1:
				occupancy[i+position-item.offset] = reshaped_occupancy[i]
				occupancy_pters[i+position-item.offset] = item
	items.append([position,item])
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
