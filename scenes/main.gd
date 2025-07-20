extends Node

@onready var choices_container := $ChoisesContainer
@onready var room_container := $RoomContainer
@onready var inventory_manager = $InventoryLayer

@export var room_data: Array[RoomData]
var next_room: int = 0

func _ready() -> void:
	var player_inventory:Inventory = inventory_manager.player_inventory
  
	# example content to try functionality
	player_inventory.add_item(ItemManager.get_item_by_name("coin"),9)

	
	init_next_room()
	pass

func init_next_room() -> void:
	room_container.init_room(room_data[next_room])
	next_room += 1

func _on_entity_clicked(options_list:Array[Dictionary]) -> void:
	print("on entity clicked")
	print(choices_container)
	choices_container.add_options_from_options_list(options_list)
	
