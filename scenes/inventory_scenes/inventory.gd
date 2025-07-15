extends Node2D
class_name Inventory

const self_scene = preload("res://scenes/inventory_scenes/inventory.tscn")

@onready var foreground := $inventory_foreground
@onready var background_rect := $background_rect
@onready var title_label := $background_rect/title_label
@onready var collision_area := $InventoryCollisionArea

@export var cols:int = 9
@export var rows:int = 3
@export var title:String = ""
var slots:int
var items = {}

var occupancy = [] # 0 if no item, 1 if item
var occupancy_positions = [] # has the same shape as occupancy, information about the position of the item there

static func constructor(cols: int, rows: int, title: String) -> Inventory:
	var obj = self_scene.instantiate()
	obj.cols = cols
	obj.rows = rows
	obj.title = title
	return obj

func _ready():
	slots = cols * rows
	for i in range(slots):
		occupancy.append(0)
		occupancy_positions.append(-1)
	
	var background_width = cols*60+10
	var background_height = rows*60+60
	background_rect.size = Vector2(background_width,background_height)
	collision_area.set_size(Vector2(background_width,background_height))
	collision_area.position = Vector2(background_width/2,background_height/2)
	foreground.initialize_item_slots(rows,cols)
	foreground.position.y = 55
	foreground.position.x = 5
	title_label.text = title
	position = Vector2(get_viewport().size/2)-Vector2(background_width/2,background_height/2)
	background_rect.connect("gui_input", _on_inventoryBackground_input)

var window_drag_offset = 0
var dragging = false

func _on_inventoryBackground_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not dragging:
			self.get_parent().get_parent().move_inventory_to_foreground(self)
			dragging = true
			window_drag_offset = position - get_global_mouse_position()
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed and dragging:
			dragging = false
			
#func _process(delta):
	#if dragging:
		#position = get_global_mouse_position() + window_drag_offset

func _physics_process(delta: float) -> void:
	var new_position = position
	#var colliding_areas = collision_area.get_overlapping_areas()
	if dragging:
		new_position = get_global_mouse_position() + window_drag_offset
		
	#for problem_area in colliding_areas:
		#problem_inventory = problem_area.get_parent()
		#if problem_inventory.dragging:
			#continue
		# To implement window collision edit here.
		
	position = new_position

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

func add_item(item,index):
	var reshaped_occupancy = _calculate_reshaped_occupancy(item)

	# does the bounding box fit?
	var bounding_box = item.bounding_box
	if (index%cols - item.offset + bounding_box[1]) > cols:
		return false
	if (int(index/cols)) + bounding_box[0] > rows:
		return false
	
	# does it collide with other items?
	for i in range(len(reshaped_occupancy)):
		if occupancy[i+index-item.offset] + reshaped_occupancy[i] >= 2:
			return false
			
	# put it in
	for i in range(len(reshaped_occupancy)):
		if reshaped_occupancy[i] >= 1:
			if reshaped_occupancy[i] == 1:
				occupancy[i+index-item.offset] = reshaped_occupancy[i]
				occupancy_positions[i+index-item.offset] = index

	items[index] = item
	foreground.add_item(index,item)
	foreground.update_occupancy(occupancy)
	return true

func remove_item(index):
	var item = _find_item_by_index(index)
	var reshaped_occupancy = _calculate_reshaped_occupancy(item)
	items.erase(index)
	for i in range(len(reshaped_occupancy)):
		if reshaped_occupancy[i] >= 1:
			occupancy[i+index-item.offset] = 0
			occupancy_positions[i+index-item.offset] = -1
	foreground.remove_item(index)
	foreground.update_occupancy(occupancy)
	return item

func _find_item_by_index(index):
	if index in items.keys():
		return items[index]
	else:
		return null
