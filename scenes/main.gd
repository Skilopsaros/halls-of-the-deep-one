extends Node

@onready var choices_container := $ChoisesContainer
@onready var room_container := $RoomContainer

@export var room_data: RoomData

func _ready() -> void:
	pass
	room_container.init_room(room_data)
	

func _on_entity_clicked(options_list:Array[Dictionary]) -> void:
	print("on entity clicked")
	print(choices_container)
	choices_container.add_options_from_options_list(options_list)
