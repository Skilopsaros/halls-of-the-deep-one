extends Node2D
class_name Inventory

const self_scene = preload("res://scenes/inventory_scenes/inventory.tscn")

@onready var foreground := $inventory_foreground
@onready var background := $inventory_background
@onready var click_layer := $click_interaction_layer
@onready var background_rect := $background_rect # TODO make bigger on top and make the whole thing draggable

@export var cols:int = 9
@export var rows:int = 3
var slots:int
var items = [] # this will be a list of tuples [position,item]
# current problem: showing two items with the bounding box at the same top left corner not possible
var occupancy = [] # 0 if no item, 1 if item
var occupancy_positions = [] # has the same shape as occupancy, information about the position of the item there

static func constructor(cols: int, rows: int) -> Inventory:
	var obj = self_scene.instantiate()
	obj.cols = cols
	obj.rows = rows
	return obj

func _ready():
	slots = cols * rows
	for i in range(slots):
		occupancy.append(0)
		occupancy_positions.append(-1)
	
	var background_width = cols*60+10
	var background_height = rows*60+60
	background_rect.size = Vector2(background_width,background_height)
	background.initialize_item_slots(rows,cols)
	foreground.initialize_item_slots(rows,cols)
	click_layer.initialize_item_slots(rows,cols)
	foreground.position.y = 60
	background.position.y = 60
	click_layer.position.y = 60
	position = Vector2(get_viewport().size/2)-Vector2(background_width/2,background_height/2)
	background_rect.connect("gui_input", _on_inventoryBackground_input)

var window_drag_offset = 0
var dragging = false

func _on_inventoryBackground_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not dragging:
			dragging = true
			window_drag_offset = position - get_global_mouse_position()
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed and dragging:
			dragging = false
			
func _process(delta):
	if dragging:
		position = get_global_mouse_position() + window_drag_offset

func _calculate_reshaped_occupancy(item_object):
	var bounding_box = item_object.bounding_box
	var occupied_spaces = item_object.occupied_spaces
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

func add_item(item_object,index):
	var reshaped_occupancy = _calculate_reshaped_occupancy(item_object)
	# attempt to put the item in
	# number one: does the bounding box fit
	var bounding_box = item_object.bounding_box
	if (index%cols - item_object.offset + bounding_box[1]) > cols:
		return false
	if (int(index/cols)) + bounding_box[0] > rows:
		return false
	
	for i in range(len(reshaped_occupancy)):
		if occupancy[i+index-item_object.offset] + reshaped_occupancy[i] >= 2:
			return false
	for i in range(len(reshaped_occupancy)):
		if reshaped_occupancy[i] >= 1:
			if reshaped_occupancy[i] == 1:
				occupancy[i+index-item_object.offset] = reshaped_occupancy[i]
				occupancy_positions[i+index-item_object.offset] = index
	items.append([index,item_object])
	foreground.add_item([index,item_object])
	background.update_item_slots(occupancy)
	return true

func remove_item(searched_index):
	var location = _find_item_by_index(searched_index)
	var inx = location[0]
	var item_object = location[1]
	var reshaped_occupancy = _calculate_reshaped_occupancy(item_object)
	items.pop_at(inx)
	for i in range(len(reshaped_occupancy)):
		if reshaped_occupancy[i] >= 1:
			occupancy[i+searched_index-item_object.offset] = 0
			occupancy_positions[i+searched_index-item_object.offset] = -1
	foreground.remove_item(searched_index)
	background.update_item_slots(occupancy)
	return item_object

func _find_item_by_index(searched_index):
	var item_object = {}
	var inx = -1
	for index in range(len(items)):
		if items[index][0] == searched_index:
			item_object = items[index][1]
			inx = index
			
	return [inx,item_object]
