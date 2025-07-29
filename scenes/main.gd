extends Node

@onready var choices_container := $ChoisesContainer
@onready var room_container := $RoomContainer
@onready var inventory_manager = $InventoryLayer
@onready var game_over_layer = $GameOverLayer
@onready var player_hud = $PlayerHud

@export var room_data: Array[RoomData]
var next_room: int = 0

func _ready() -> void:
	var player_inventory:Inventory = inventory_manager.player_inventory
	# example content to try functionality
	player_inventory.add_item(ItemManager.get_item_by_name("coin"),9)
	player_inventory.add_item(ItemManager.get_item_by_name("gem"),6)
	player_inventory.add_item(ItemManager.get_item_by_name("gem"),7)
	player_inventory.add_item(ItemManager.get_item_by_name("amulet"),2)
	player_inventory.add_item(ItemManager.get_item_by_name("frog"),0)
	player_inventory.add_item(ItemManager.get_item_by_name("knife"),15)
	player_inventory.add_item(ItemManager.get_item_by_name("shoe"),18)
	
	var chest:Inventory = inventory_manager.add_inventory(4,5,"goodies")
  
	start_game()
	pass

func game_over() -> void:
	game_over_layer.show()

func start_game() -> void:
	game_over_layer.hide()
	await player_hud.new_character()
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
	
