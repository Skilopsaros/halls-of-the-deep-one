extends Control
class_name Inventory

@onready var items:Node = $InventoryLayer/Items
@onready var title_label:Label = $HBoxContainer/Label
@onready var inventory_layer:TileMapLayer = $InventoryLayer
@onready var closing_x:TextureButton = $HBoxContainer/ClosingX
@onready var minimizing_v:TextureButton = $HBoxContainer/MinimizingV
@onready var movement_handle:TextureRect = $HBoxContainer/MovementHandle

signal cell_clicked
signal inventory_changed
signal inventory_closing

const world_atlas_id:int = 0
const self_scene:PackedScene = preload("res://scenes/inventory_scenes/inventory/inventory.tscn")

@export var rows:int = 6
@export var cols:int = 6
@export var input_supressed = false
@export var title:String
@export var filters:Array[Enums.item_tags] = [] # each element is a key that an item needs to have to be accepted
# if multiple keys are given all of them need to be fulfilled
@export var closes_on_item_placement:bool = false
@export var closable:bool = false
@export var minimizable:bool = false
@export var movable:bool = false
enum TILES {OCCUPIED,FREE,INACTIVE}

var occupancy_dict:Dictionary = {}
var active_list:Array[Vector2i] = []

static func constructor(new_rows: int, new_cols: int, new_title:String, new_closable:bool ,new_minimizable:bool, new_movable:bool = true, initial_active_list:Array[Vector2i]=[]) -> Inventory:
	var obj:Inventory = self_scene.instantiate()
	obj.rows = new_rows
	obj.cols = new_cols
	obj.title = new_title
	obj.closable = new_closable
	obj.minimizable = new_minimizable
	obj.movable = new_movable
	obj.active_list = initial_active_list.duplicate() # we do not want any call by reference bugs
	return obj

func set_active_list(new_active_list:Array[Vector2i]) -> void:
	active_list = new_active_list.duplicate()
	update_inventory_tiles()

func _gui_input(event:InputEvent) -> void:
	if input_supressed:
		return
	if event is InputEventMouseButton:
		if event.is_pressed():
			var global_clicked:Vector2 = get_local_mouse_position()
			var pos_clicked:Vector2i = inventory_layer.local_to_map(global_clicked)
			if inventory_layer.get_cell_tile_data(pos_clicked) != null:
				print(pos_clicked)
				cell_clicked.emit(event,pos_clicked,self)

func _ready() -> void:
	title_label.text = title
	update_inventory_tiles()
	update_top_bar_tools_visibility()
	size.x = cols*30
	size.y = rows*30
	$ColorRect.size.x = cols*30

var window_drag_offset:Vector2 = Vector2(0.0,0.0)
var dragging:bool = false

func _on_movement_handle_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if movable and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not dragging:
			self.get_parent().get_parent().move_inventory_to_foreground(self)
			dragging = true
			window_drag_offset = position - get_global_mouse_position()
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and dragging:
			dragging = false
			
func _process(_delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() + window_drag_offset

func check_placement(item:ItemObject,coordinate:Vector2i) -> bool:
	for position_vector in item.occupancy: # vectors in godot are value types.
		# rotate position_vector
		for i in range(item.orientation):
			position_vector = Vector2i(-position_vector[1],position_vector[0])
		var global_coordinate = coordinate + position_vector
		if inventory_layer.get_cell_tile_data(global_coordinate) == null or inventory_layer.get_cell_tile_data(global_coordinate).terrain_set != TILES.FREE:
			# out of bounds or inactive inventory slot
			return false
		if global_coordinate in occupancy_dict and occupancy_dict[global_coordinate] != null:
			# occupied
			return false
	return true

func _check_filter_ok(item: ItemObject) -> bool:
	for filter in filters:
		if filter not in item.data.tags:
			return false
	return true

func add_item(item:ItemObject,coordinate:Vector2i) -> bool:
	if not check_placement(item,coordinate) or not _check_filter_ok(item):
		return false
	if item.inventory and item.inventory == self: # don't put a bag into itself please
		return false
	# if so update everything
	item.location = coordinate
	add_occupancy(item)
	item.reparent(items)
	update_item_position(item)
	update_inventory_tiles()
	inventory_changed.emit(self,item,"add")
	if not visible:
		item.visible = false
	if closes_on_item_placement:
		emit_signal("inventory_closing", self)
	return true
	
func remove_item(item_to_remove:ItemObject) -> ItemObject:
	remove_occupancy(item_to_remove)
	update_inventory_tiles()
	items.remove_child(item_to_remove)
	inventory_changed.emit(self,item_to_remove,"remove")
	return item_to_remove
	
func remove_item_by_name(item_name: String) -> ItemObject:
	for item in items.get_children():
		if item.data.name == item_name:
			return remove_item(item)
	return null
	
func remove_item_by_coordinate(coordinate:Vector2i) -> ItemObject:
	if not coordinate in occupancy_dict or occupancy_dict[coordinate] == null:
		return null
	var item:ItemObject = occupancy_dict[coordinate]
	remove_item(item)
	return item

func add_item_at_first_possible_position(item: ItemObject) -> Vector2i:
	if not _check_filter_ok(item):
		return Vector2i(-1,-1)
		
	for i in range(cols):
		for j in range(rows):
			for k in range(4):
				if add_item(item,Vector2i(i,j)):
					return Vector2i(i,j)
				item.rotate_90()
	return Vector2i(-1,-1)

func update_item_position(item:ItemObject) -> void:
	var rotated_origin = item.origin # vectors are copied by value by default
	for _i in range(item.orientation):
		rotated_origin = Vector2i(-rotated_origin[1],rotated_origin[0])
	var world_position:Vector2 = inventory_layer.map_to_local(item.location)
	item.position = world_position

func add_occupancy(item:ItemObject) -> void:
	for position_vector in item.occupancy:
		for i in range(item.orientation):
			position_vector = Vector2i(-position_vector[1],position_vector[0])
		var global_coordinate = item.location  + position_vector
		occupancy_dict[global_coordinate] = item
		
func remove_occupancy(item:ItemObject) -> void:
	if item == null:
		return
	for position_vector in item.occupancy:
		for i in range(item.orientation):
			position_vector = Vector2i(-position_vector[1],position_vector[0]) # hexagon grid rotation 60°
		var global_coordinate = item.location + position_vector
		occupancy_dict[global_coordinate] = null

func update_inventory_tiles() -> void:
	for i:int in range(cols):
		for j:int in range(rows):
			var coordinate := Vector2i(i,j)
			var tile_to_put:int
			if len(active_list) != 0 and not coordinate in active_list:
				tile_to_put = TILES.INACTIVE
			elif coordinate in occupancy_dict.keys() and occupancy_dict[coordinate] != null:
				tile_to_put = TILES.OCCUPIED
			else:
				tile_to_put = TILES.FREE
			var tile_coordinate = inventory_layer.tile_set.get_source(world_atlas_id).get_tile_id(tile_to_put)
			inventory_layer.set_cell(coordinate,world_atlas_id,tile_coordinate)

func get_total_value() -> int:
	var total_value: int = 0
	for item in items.get_children():
		total_value += item.data.value
	return total_value

func get_contained_tags() -> Array[Enums.item_tags]:
	var tags:Array[Enums.item_tags] = []
	for item:ItemObject in items.get_children():
		for tag in item.data.tags:
			if not tag in tags:
				tags.append(tag)
	return tags

func _on_visibility_changed() -> void:
	self.propagate_call("set_visible", [self.visible])
	update_top_bar_tools_visibility()

func update_top_bar_tools_visibility() -> void:
	if not closable and closing_x:
		closing_x.hide()
	if not minimizable and minimizing_v:
		minimizing_v.hide()
	if not movable and movement_handle:
		movement_handle.hide()

func _on_closing_x_pressed() -> void:
	self.inventory_closing.emit(self)


func _on_minimizing_v_pressed() -> void:
	self.visible = false
