extends Resource
class_name Item

@export var name: String
@export var texture: Texture
@export var tags: Array[String]
@export var value: int
@export_multiline var occupation_matrix: String
var occupancy: Array = []
var offset: int
var bounding_box: Vector2i

func _ready()->void:
	resource_local_to_scene = true
	_derive_occupancy()
	_derive_bounding_box()
	_derive_offet()

func _derive_occupancy()->void:
	var occupancy_temp:Array = []
	var rows: PackedStringArray = occupation_matrix.split("\n")
	for row in rows:
		occupancy_temp.append(row.split(","))
	
	occupancy.resize(len(occupancy_temp))
	for i in range(len(occupancy_temp)):
		var row_temp:Array[int] = []
		row_temp.resize(len(occupancy_temp[i]))
		for j in range(len(occupancy_temp[i])):
			row_temp[j] = int(occupancy_temp[i][j])
		occupancy[i] = row_temp

func _derive_bounding_box()->void:
	bounding_box.x = len(occupancy)
	bounding_box.y = len(occupancy[0])

func _derive_offet()->void:
	var first_line:Array[int] = occupancy[0]
	var i:int = 0
	while first_line[i] == 0:
		i+=1
	offset = i

func _rotate_item(clockwise:bool)->void:
	pass # implement roation here
	_init()
