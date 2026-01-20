extends Node2D
class_name Inventory

signal inventory_changed
signal inventory_closing
signal inventory_reshaped

const self_scene:PackedScene = preload("res://scenes/inventory_scenes/inventory/inventory.tscn")

@onready var foreground := $Foreground
@onready var background_rect := $BackgroundRect
@onready var background_rect_inner_color := $BackgroundRect/InnerColorRect
@onready var title_label := $BackgroundRect/Title
@onready var closing_x := $BackgroundRect/ClosingX

@onready var decoration_ctrl := $Decoration

@export var cols:int = 9
@export var rows:int = 3
@export var title:String = ""
@export var filters:Array[Enums.item_tags] = [] # each element is a key that an item needs to have to be accepted
# if multiple keys are given all of them need to be fulfilled
@export var closeable:bool = true
@export var closes_on_item_placement:bool = false
var closing_check: Callable = default_close_condition

var slots:int
var items:Dictionary[int, Item] = {}

var occupancy:Array[int] = [] # 0 if no item, 1 if item
var occupancy_positions:Array[int] = [] # has the same shape as occupancy, information about the position of the item there

static func constructor(cols: int, rows: int, title: String) -> Inventory:
	var obj := self_scene.instantiate()
	obj.cols = cols
	obj.rows = rows
	obj.title = title
	return obj

func _ready() -> void:
	slots = cols * rows
	for i in range(slots):
		occupancy.append(0)
		occupancy_positions.append(-1)
	
	var background_width:int = cols*30+2
	var background_height:int = rows*30+21
	background_rect.size = Vector2(background_width,background_height)
	background_rect_inner_color.size = Vector2(background_rect.size.x - 2,18)
	background_rect_inner_color.position = Vector2(1,1)
	foreground.initialize_item_slots(rows,cols)
	foreground.position.y = 40
	foreground.position.x = 2
	if !closeable:
		closing_x.hide()
	_recalculate_decoration()
	title_label.text = title
	position = Vector2(get_viewport().size/2)-Vector2(background_width,background_height)
	background_rect.connect("gui_input", _on_inventory_background_input)
	inventory_changed.emit(self,null,"ready")

@export var draggable:bool = true
var window_drag_offset:Vector2 = Vector2(0.0,0.0)
var dragging:bool = false

func _on_inventory_background_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if draggable and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not dragging:
			self.get_parent().get_parent().move_inventory_to_foreground(self)
			dragging = true
			window_drag_offset = position - get_global_mouse_position()
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and dragging:
			dragging = false
			
func _process(delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() + window_drag_offset

func _calculate_reshaped_occupancy(item: Item) -> Array[int]:
	var bounding_box:Vector2i = item.bounding_box
	var occupied_spaces:Array = item.occupancy # :Array[Array[int]]
	var reshaped_occupied_spaces:Array[int] = []
	var buffer_length:int = int(cols - bounding_box[1])
	var buffer:Array[int] = []
	buffer.resize(buffer_length)
	buffer.fill(0)
	for row in occupied_spaces:
		reshaped_occupied_spaces.append_array(row)
		reshaped_occupied_spaces.append_array(buffer)
	reshaped_occupied_spaces.reverse() # it's not pretty but it works
	for i in range(buffer_length):
		reshaped_occupied_spaces.remove_at(0)
	reshaped_occupied_spaces.reverse()
	return reshaped_occupied_spaces

func _check_filter_ok(item: Item) -> bool:
	for filter in filters:
		if filter not in item.tags:
			return false
	return true

func default_close_condition(inventory) -> bool:
	return(true)

func add_item(item: Item, index: int) -> bool:
	if not _check_filter_ok(item):
		return false
		
	var reshaped_occupancy := _calculate_reshaped_occupancy(item)

	# does the bounding box fit?
	var bounding_box:Vector2i = item.bounding_box
	if (index%cols - item.offset + bounding_box.y) > cols:
		return false
	if (index%cols - item.offset) < 0:
		return false
	if (int(index/cols)) + bounding_box.x > rows:
		return false
	
	# does it collide with other items?
	for i in range(len(reshaped_occupancy)):
		if occupancy[i+index-item.offset] + reshaped_occupancy[i] >= 2:
			return false
			
	# put it in
	for i in range(len(reshaped_occupancy)):
		if reshaped_occupancy[i] == 1:
			occupancy[i+index-item.offset] = int(reshaped_occupancy[i])
			occupancy_positions[i+index-item.offset] = index

	items[index] = item
	foreground.add_item(index,item)
	foreground.update_occupancy(occupancy)
	inventory_changed.emit(self,item,"add")
	if closes_on_item_placement and closing_check.call(self):
		emit_signal("inventory_closing", self)
	return true
	
func add_item_at_first_possible_position(item: Item) -> int:
	if not _check_filter_ok(item):
		return -1
		
	for i in range(cols*rows):
		for j in range(4):
			if add_item(item,i):
				return i
			item.rotate()
			
	return -1

func remove_item_by_name(name: String) -> Item:
	for index in items.keys():
		if items[index].name == name:
			return remove_item(index)
	return null

func remove_item(index: int) -> Item:
	var item := _find_item_by_index(index)
	var reshaped_occupancy := _calculate_reshaped_occupancy(item)
	items.erase(index)
	for i in range(len(reshaped_occupancy)):
		if reshaped_occupancy[i] >= 1:
			occupancy[i+index-item.offset] = 0
			occupancy_positions[i+index-item.offset] = -1
	foreground.remove_item(index)
	foreground.update_occupancy(occupancy)
	inventory_changed.emit(self,item,"remove")
	return item

func _find_item_by_index(index: int) -> Item:
	if index in items.keys():
		return items[index]
	else:
		return null

func _recalculate_decoration() -> void:
	decoration_ctrl.size = background_rect.size
	if (decoration_ctrl.size.x - 120) / 4 > 10:
		var border_tl:TextureRect = $Decoration/BorderTL
		border_tl.size.x = (decoration_ctrl.size.x - 120) / 4
		var border_tr:TextureRect = $Decoration/BorderTR
		border_tr.size.x = (decoration_ctrl.size.x - 120) / 4
	else:
		var border_tl:TextureRect = $Decoration/BorderTL
		border_tl.hide()
		var border_tr:TextureRect = $Decoration/BorderTR
		border_tr.hide()

func get_contained_tags() -> Array[Enums.item_tags]:
	var tags:Array[Enums.item_tags] = []
	for key in items.keys():
		var item:Item = items[key]
		for tag in item.tags:
			if not tag in tags:
				tags.append(tag)
	return tags
	

func _closing_x_pressed(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("inventory_closing", self)

func get_total_value() -> int:
	var total_value: int = 0
	for key in items.keys():
		total_value += items[key].value
	return total_value

func resize(new_rows:int,new_cols:int)->void:
	# remove all items
	var positions:Array[int] = []
	var contained_items:Array[Item] = []
	var worked:Array[bool] = []
	for key in items.keys():
		positions.append(key)
		contained_items.append(items[key])
		worked.append(false)
		remove_item(key)
	
	var old_cols:int = cols
	cols = new_cols
	rows = new_rows
	slots = cols * rows
	occupancy = []
	occupancy_positions = []
	for i in range(slots):
		occupancy.append(0)
		occupancy_positions.append(-1)
	foreground.reshape(new_rows,new_cols)
	# update occupancy checks
	# put them back
	for index in range(len(positions)):
		var pos := positions[index]
		var item := contained_items[index]
		var pos_x = pos%old_cols
		var pos_y = floor(pos/old_cols)
		
		if new_cols > pos_x and new_rows > pos_y:
			# we can try to put it back where it was
			var new_pos = pos_y*new_cols+pos_x
			var success = add_item(item,new_pos)
			worked[index] = success
	
	# now put all the remaining ones in if possible
	for index in range(len(positions)):
		if not worked[index]:
			add_item_at_first_possible_position(contained_items[index])
	
	var background_width:int = cols*30+2
	var background_height:int = rows*30+21
	background_rect.size = Vector2(background_width,background_height)
	background_rect_inner_color.size = Vector2(background_rect.size.x - 2,18)
	inventory_reshaped.emit(self)
