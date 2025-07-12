extends Node

@onready var inventory_manager = $InventoryLayer

func _ready():
	var player_inventory = inventory_manager.player_inventory
	player_inventory.add_item(Global.get_item_by_key("shoe"),1)
	#player_inventory.remove_item(8)
	
	var chest = inventory_manager.add_inventory(2,2)
	chest.add_item(Global.get_item_by_key("coin"),1)
	
	player_inventory.add_item(Global.get_item_by_key("coin"),16)
	player_inventory.add_item(Global.get_item_by_key("gem"),8)
	player_inventory.add_item(Global.get_item_by_key("amulet"),12)
