extends Node2D
class_name Room

@export var data: RoomData

@onready var room_art: Texture = data.room_art
@onready var entities: Array[EntityStack] = data.entities

@onready var room_art_scene := $RoomArt
@onready var hbox_container := $HBoxContainer

func _ready() -> void:
	room_art_scene.texture = room_art
	load_entities()
	
func load_entities() -> void:
	for entity_stack in entities:
		var new_entity = entity_stack.entities[0].instantiate() ### <<< FIX THIS, ONLY LOADING FIRST ENTITY IN STACK
		hbox_container.add_child(new_entity)
