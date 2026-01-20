extends Node

@onready var choices_container := $ChoisesContainer
@onready var room_container := $RoomContainer
@onready var inventory_manager := $InventoryLayer
@onready var game_over_layer := $GameOverLayer
@onready var player_hud := $PlayerHud
@onready var menu_hud := $MenuHud
@onready var dice_layer := $DiceLayer
@onready var dice := [$DiceLayer/Die_0, $DiceLayer/Die_1]
@onready var dice_results_label := $DiceLayer/Results

@export var room_data: Array[RoomData]
var next_room: int = 0

func _ready() -> void:
	var player_inventory:Inventory = inventory_manager.player_inventory
	# example content to try functionality
	player_inventory.add_item(ItemManager.get_item_by_name("gem"),7)
	player_inventory.add_item(ItemManager.get_item_by_name("amulet"),2)
	player_inventory.add_item_at_first_possible_position(ItemManager.get_item_by_name("coin"))
	player_inventory.add_item_at_first_possible_position(ItemManager.get_item_by_name("backpack"))
	#for i in range(20):
		#player_inventory.add_item_at_first_possible_position(ItemManager.get_item_by_name("coin"))
	#menu_hud.clear_log()
	#player_inventory.resize(4,15)
	#menu_hud.add_message_to_log("A dark aura surrounds you")
	#menu_hud.add_message_to_log("You lost 15 health")
	#var chest:Inventory = inventory_manager.add_inventory(4,5,"CHEST")
  
	start_game()
	pass

func game_over() -> void:
	game_over_layer.show()

func start_game() -> void:
	choices_container.clear_options()
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

func _on_entity_clicked(options_list:Array[Dictionary], entity:Entity) -> void:
	choices_container.add_options_from_options_list(options_list, entity)

func roll_dice(add:int=0, target:int=7) -> bool:
	dice_layer.show()
	var dice_results: Array[int] = [0,0]
	var sum: int = add
	for i in range(2):
		dice_results[i] = dice[i].roll()
		sum += dice_results[i]
	await get_tree().create_timer(1.250).timeout
	dice_results_label.text = "(" + str(dice_results[0]) + " + " + str(dice_results[1]) + ") + "+ str(add) + " = " + str(sum)
	var pass_check : bool = sum >= target
	if pass_check:
		dice_results_label.text += "\n Success!"
	else:
		dice_results_label.text += "\n Failiure!"
	dice_results_label.show()
	await get_tree().create_timer(4.000).timeout
	dice_results_label.hide()
	dice_layer.hide()
	return pass_check

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("test_key"):
		roll_dice()
		
func log(message: String) -> void:
	menu_hud.add_message_to_log(message)
