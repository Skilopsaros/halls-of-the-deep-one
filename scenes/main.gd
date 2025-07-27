extends Node

@onready var choices_container := $ChoisesContainer
@onready var room_container := $RoomContainer
@onready var inventory_manager = $InventoryLayer
@onready var game_over_layer = $GameOverLayer

@export var room_data: Array[RoomData]
var next_room: int = 0

func _ready() -> void:
	var player_inventory:Inventory = inventory_manager.player_inventory
  
	# example content to try functionality
	var chest:Inventory = inventory_manager.add_inventory(5,3,"Chest")
	chest.add_item(item_library.get_item_by_key("coin"),0)
	chest.add_item(item_library.get_item_by_key("frog"),1)
	player_inventory.add_item(item_library.get_item_by_key("coin"),9)
	player_inventory.add_item(item_library.get_item_by_key("gem"),8)
	player_inventory.add_item(item_library.get_item_by_key("shoe"),13)

	start_game()
	pass

func game_over() -> void:
	game_over_layer.show()

func start_game() -> void:
	game_over_layer.hide()
	var character = get_node("/root/Main/PlayerHud").character
	character.died.connect(game_over)
	character.insane.connect(game_over)
	character.init_character()
	next_room = 0
	init_next_room()

func init_next_room() -> void:
	room_container.init_room(room_data[next_room])
	next_room += 1

func _on_entity_clicked(options_list:Array[Dictionary]) -> void:
	choices_container.add_options_from_options_list(options_list)
