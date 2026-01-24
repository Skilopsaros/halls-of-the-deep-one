extends TileMapLayer
class_name Inventory

@onready var items:Node = $Items
@onready var title_label:Label = $Label

signal cell_clicked
signal inventory_changed

const world_atlas_id:int = 0
const self_scene:PackedScene = preload("res://scenes/inventory_scenes/inventory/inventory_window.tscn")

@export var rows:int = 6
@export var cols:int = 6
@export var input_supressed = false
@export var title:String
@export var filters:Array[Enums.item_tags] = [] # each element is a key that an item needs to have to be accepted
# if multiple keys are given all of them need to be fulfilled
enum TILES {OCCUPIED,FREE,INACTIVE}

var occupancy_dict:Dictionary = {}
var active_list:Array[Vector2i] = []

static func constructor(new_rows: int, new_cols: int, new_title:String, initial_active_list:Array[Vector2i]=[]) -> Inventory:
	var obj:Inventory = self_scene.instantiate()
	obj.rows = new_rows
	obj.cols = new_cols
	obj.title = new_title
	obj.active_list = initial_active_list.duplicate() # we do not want any call by reference bugs
	return obj

func _unhandled_input(event:InputEvent) -> void:
	if input_supressed:
		return
	if event is InputEventMouseButton:
		if event.is_pressed():
			var global_clicked:Vector2 = get_local_mouse_position()
			var pos_clicked:Vector2i = local_to_map(global_clicked)
			if get_cell_tile_data(pos_clicked) != null:
				cell_clicked.emit(event,pos_clicked,self)

func _ready() -> void:
	title_label.text = title
	for i:int in range(cols):
		for j:int in range(rows):
			var coordinate := Vector2i(i,j)
			var tile_coordinate:Vector2i
			# temporary behaviour:
			active_list.append(coordinate)
			if coordinate in active_list:
				tile_coordinate = tile_set.get_source(world_atlas_id).get_tile_id(TILES.FREE)
			else:
				tile_coordinate = tile_set.get_source(world_atlas_id).get_tile_id(TILES.INACTIVE)
			set_cell(Vector2(i,j),world_atlas_id,tile_coordinate)

func check_placement(item:ItemObject,coordinate:Vector2i) -> bool:
	for position_vector in item.occupancy: # vectors in godot are value types.
		# rotate position_vector
		for i in range(item.orientation):
			position_vector = Vector2i(-position_vector[1],position_vector[0])
		var global_coordinate = coordinate + position_vector
		if get_cell_tile_data(global_coordinate) == null or get_cell_tile_data(global_coordinate).terrain_set != TILES.FREE:
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
	# if so update everything
	item.location = coordinate
	add_occupancy(item)
	update_item_position(item)
	item.reparent(items)
	update_inventory_tiles()
	inventory_changed.emit(self,item,"add")
	return true

func remove_item(coordinate:Vector2i) -> ItemObject:
	if not coordinate in occupancy_dict or occupancy_dict[coordinate] == null:
		return null
	var item:ItemObject = occupancy_dict[coordinate]
	remove_occupancy(item)
	update_inventory_tiles()
	items.remove_child(item)
	inventory_changed.emit(self,item,"remove")
	return item

func update_item_position(item:ItemObject) -> void:
	var rotated_origin = item.origin # vectors are copied by value by default
	for _i in range(item.orientation):
		rotated_origin = Vector2i(-rotated_origin[1],rotated_origin[0])
	var world_position:Vector2 = to_global(map_to_local(item.location))
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
			if not coordinate in active_list:
				tile_to_put = TILES.INACTIVE
			elif coordinate in occupancy_dict.keys() and occupancy_dict[coordinate] != null:
				tile_to_put = TILES.OCCUPIED
			else:
				tile_to_put = TILES.FREE
			var tile_coordinate = tile_set.get_source(world_atlas_id).get_tile_id(tile_to_put)
			set_cell(coordinate,world_atlas_id,tile_coordinate)

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
