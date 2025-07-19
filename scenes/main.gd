extends Node

@onready var choices_container := $ChoisesContainer
@onready var room_container := $RoomContainer
@onready var inventory_manager = $InventoryLayer

@export var room_data: Array[RoomData]
var next_room: int = 0

func _ready() -> void:
	var player_inventory:Inventory = inventory_manager.player_inventory
  
	# example content to try functionality
	player_inventory.add_item(item_library.get_item_by_key("coin"),9)
	player_inventory.add_item(item_library.get_item_by_key("gem"),8)
	player_inventory.add_item(item_library.get_item_by_key("shoe"),13)
	player_inventory.add_item(item_library.get_item_by_key("knife"),0)
	player_inventory.add_item(item_library.get_item_by_key("sword"),5)
	player_inventory.add_item(item_library.get_item_by_key("amulet"),2)
  
	init_next_room()
	pass

func init_next_room() -> void:
	room_container.init_room(room_data[next_room])
	next_room += 1

func _on_entity_clicked(options_list:Array[Dictionary]) -> void:
	print("on entity clicked")
	print(choices_container)
	choices_container.add_options_from_options_list(options_list)
	
