extends Node2D
class_name Room

signal clear_choices

@export var data: RoomData

@onready var room_art: Texture = data.room_art
@onready var entity_stacks: Array[EntityStack] = data.entities
var active_entities: Array[Entity] = []
var active_entity_stack_indexes: Array[int] = []

@onready var room_art_scene := $RoomArt
@onready var hbox_container := $HBoxContainer

func _ready() -> void:
	room_art_scene.texture = room_art
	for i in range(len(entity_stacks)):
		active_entity_stack_indexes.append(0)
		active_entities.append(Entity.new())
	load_all_entities()
	
func load_all_entities() -> void:
	for index in range(len(entity_stacks)):
		load_entity(index)

func remove_entity(index:int) -> void:
	emit_signal("clear_choices")
	print(active_entities[index])
	active_entities[index].queue_free()
	await active_entities[index].tree_exited
	active_entity_stack_indexes[index] += 1
	if len(entity_stacks[index].entities) > active_entity_stack_indexes[index]:
		load_entity(index)
		
func load_entity(index:int) -> void:
	var new_entity = entity_stacks[index].entities[active_entity_stack_indexes[index]].new()
	new_entity.entity_clicked.connect(get_node("/root/Main")._on_entity_clicked)
	new_entity.clear_entity.connect(remove_entity)
	hbox_container.add_child(new_entity)
	active_entities[index] = new_entity
	new_entity.index = index
