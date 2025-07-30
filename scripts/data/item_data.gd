extends Resource
class_name Item

@export var name: String # in code reference name
@export var title: String # in game display name
@export var texture: Texture
@export_multiline var occupancy_matrix: String
@export var tags: Array[String]
@export_group("Equip stat modifiers")
@export var stat_modifiers: Dictionary[String, int] = {
	"power" = 0,
	"agility" = 0,
	"perception" = 0,
	"occult" = 0
}
@export_group("Various")
@export var value: int
@export var movable: bool = true
@export_multiline var flavour_text:String
var occupancy: Array = [] # Array[Array[int]]
var offset: int # in inventory containers
var draw_offset: Vector2 # in screen pixels
var bounding_box: Vector2i
var rotation: int = 0 # in multiplees of 90° clockwise

func _ready()->void:
	_derive_occupancy()
	_derive_bounding_box()
	_derive_offet()
	_derive_draw_offset()

func _derive_occupancy()->void:
	var occupancy_temp:Array = []
	var rows: PackedStringArray = occupancy_matrix.split("\n")
	if rows[-1] == "": # in case there is an extra newline character at the end
		rows = rows.slice(0,-1)
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

func rotate()->void:
	# rotate clockwise
	# by first mirroring about the diagonal and then mirroring horizontally
	var new_occupancy: Array = []
	new_occupancy.resize(bounding_box.y)
	for i in range(len(new_occupancy)):
		var new_row: Array[int] = []
		new_row.resize(bounding_box.x)
		for j in range(len(new_row)):
			new_row[j] = occupancy[j][i]
		new_row.reverse()
		new_occupancy[i] = new_row
	rotation += 1 # keep track of where we are
	rotation %= 4
	occupancy = new_occupancy
	_derive_bounding_box()
	_derive_offet()
	_derive_draw_offset()
		
func _derive_draw_offset()->void:
	draw_offset = Vector2(0,0)
	match rotation:
		0:
			pass
		1:
			draw_offset += Vector2((bounding_box.y)*40,0)
			draw_offset += Vector2((bounding_box.y-1)*20,0)
		2:
			draw_offset += Vector2((bounding_box.y)*40,(bounding_box.x)*40)
			draw_offset += Vector2((bounding_box.y-1)*20,(bounding_box.x-1)*20)
		3:
			draw_offset += Vector2(0,(bounding_box.x)*40)
			draw_offset += Vector2(0,(bounding_box.x-1)*20)
	draw_offset -= Vector2(offset*60,0)	

func _on_equip(character: Character):
	for stat in stat_modifiers:
		print("in on equip")
		character.change_stat(stat, stat_modifiers[stat])

func _on_unequip(character: Character):
	for stat in stat_modifiers:
		character.change_stat(stat, -stat_modifiers[stat])
