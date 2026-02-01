extends Node
class_name Main

@onready var choices_container := $ChoisesContainer
@onready var room_container := $RoomContainer
@onready var inventory_manager := $InventoryLayer
@onready var game_over_layer := $GameOverLayer
@onready var game_over_text := $GameOverLayer/GameOver
@onready var game_over_score := $GameOverLayer/Score
@onready var player_hud := $PlayerHud
@onready var menu_hud := $MenuHud
@onready var log_hud := $LogHud
@onready var dice_layer := $DiceLayer
@onready var dice := [$DiceLayer/Die_0, $DiceLayer/Die_1]
@onready var dice_results_label := $DiceLayer/Results
@onready var room_generator := $RoomGenerator


@export var level_data: LevelData
var room_number: int = 0

func _ready() -> void:
	# example content to show functionality
	var player_inventory:Inventory = inventory_manager.player_inventory
	# Setting active slots:
	# best only done on an empty inventory, otherwise behaviour get's strange when you disable occupied slots
	# player_inventory.set_active_list([Vector2i(0,0),Vector2i(1,0),Vector2i(1,1),Vector2i(4,4)])
	
	
	# example content to try functionality
	player_inventory.add_item(ItemManager.get_item_by_name("plokamarchidi"),Vector2i(1,1))
	player_inventory.add_item(ItemManager.get_item_by_name("strange_brew"),Vector2i(3,3))
	player_inventory.add_item_at_first_possible_position(ItemManager.get_item_by_name("gold_coin"))
	#player_inventory.add_item_at_first_possible_position(ItemManager.get_item_by_name("backpack"))
	start_game()
	pass

func game_over() -> void:
	game_over_score.hide()
	game_over_text.show()
	game_over_layer.show()

func exited() -> void:
	var score: int = inventory_manager.player_inventory.get_total_value()
	game_over_score.text = str(score)
	game_over_score.show()
	game_over_text.hide()
	game_over_layer.show()


func start_game() -> void:
	choices_container.clear_options()
	game_over_layer.hide()
	inventory_manager.player_inventory.clear_inventory()
	inventory_manager.player_weapon.clear_inventory()
	inventory_manager.player_armour.clear_inventory()
	inventory_manager.player_accessory.clear_inventory()
	await player_hud.new_character()
	var character = get_node("/root/Main/PlayerHud").character
	inventory_manager.player_inventory.set_active_list(character.get_starting_inventory_active_list(20))
	character.died.connect(game_over)
	character.insane.connect(game_over)
	character.init_character()
	room_number = 0
	init_next_room()

func init_next_room() -> void:
	room_number += 1
	room_container.init_room(room_generator.make_room(level_data, room_number))

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
		log_message("hello")
		
func log_message(message: String) -> void:
	log_hud.add_message(message)
