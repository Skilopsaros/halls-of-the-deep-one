extends Sprite2D

class_name ItemObject

var data:Item
var location:Vector2i
var orientation:int = 0
var origin:Vector2i # the point in the item where it will be grabbed and from where the occupancy is calculated
var occupancy:Array[Vector2i]
var bounding_box:Vector2i
const self_scene:PackedScene = preload("res://scenes/inventory_scenes/item_object.tscn")

var inventory:Inventory = null # only used for container items

var hover_counter:float
var hovering:bool = false
var hover_info_subject:bool = false

static func constructor(item_data:Item) -> ItemObject:
	var obj := self_scene.instantiate()
	item_data = item_data.duplicate()
	obj.data = item_data
	return obj

func _ready() -> void:
	texture = data.texture
	#hover_info.display_item_data(data)
	_derive_occupancy()
	#_create_collision_shape()

func rotate_90() -> void:
	orientation = (orientation + 1) % 4
	rotation = PI/2*orientation
	#hover_info.rotation = -rotation

func _derive_occupancy() -> void:
	var occupancy_temp:Array[PackedStringArray] = []
	var rows: PackedStringArray = data.occupancy_matrix.split("\n")
	if rows[-1] == "": # in case there is an extra newline character at the end
		rows = rows.slice(0,-1)
	for row in rows:
		var temp = row.split(",")
		occupancy_temp.append(temp)
	
	bounding_box.y = len(occupancy_temp) # vertical
	bounding_box.x = len(occupancy_temp[0]) # horizontal
	origin = Vector2i(0,0)
	for entry in occupancy_temp[0]:
		if entry == '0':
			origin[0] += 1 # yes the indexing is weird but I need to flip the dimensions in a second
		else:
			break
	offset = Vector2(-10,-10) - origin*30.
	# transpose the thing because the tilemap is column indexed
	var occupancy_temp_transposed:Array[Array] = _transpose(occupancy_temp)
	
	for i in range(len(occupancy_temp_transposed)):
		for j in range(len(occupancy_temp_transposed[i])):
			if occupancy_temp_transposed[i][j] == '1':
				occupancy.append(Vector2i(i,j) - origin)

#func _create_collision_shape() -> void:
	#for position_vector in occupancy:
		#var coll_shape := CollisionShape2D.new()
		#coll_shape.shape = RectangleShape2D.new()
		#coll_shape.shape.size = Vector2(30,30)
		#coll_shape.position = position_vector*30
		#collision_area.add_child(coll_shape)

func _on_equip(character: Character) -> void:
	for stat in data.stat_modifiers:
		character.change_stat(stat, data.stat_modifiers[stat])

func _on_unequip(character: Character) -> void:
	for stat in data.stat_modifiers:
		character.change_stat(stat, -data.stat_modifiers[stat])

func _transpose(arr) -> Array[Array]:
	var height:int = arr.size()
	var width:int = arr.front().size()
	var new_arr:Array[Array] = []

	# Make a 2d array
	for i:int in range(width):
		var row:Array = []
		row.resize(height)
		new_arr.append(row)

	# Swap the rows and columns
	for i:int in range(height):
		for j:int in range(width):
			new_arr[j][i] = arr[i][j]

	return new_arr

func _on_visibility_changed() -> void:
	if inventory:
		inventory.visible = false

func destroy_self() -> void:
	if inventory:
		inventory.inventory_closing.emit(inventory)
	self.queue_free()

static func item_size_sorter(a:ItemObject,b:ItemObject) -> bool:
	if len(a.occupancy) > len(b.occupancy):
		return true
	else:
		return false
