extends Node

@onready var inventory_manager = $InventoryLayer

func _ready() -> void:
	var player_inventory:Inventory = inventory_manager.player_inventory
	
	# example content to try functionality
	var chest:Inventory = inventory_manager.add_inventory(5,3,"Chest")
	chest.add_item(item_library.get_item_by_key("coin"),0)
	chest.add_item(item_library.get_item_by_key("frog"),1)
	player_inventory.add_item(item_library.get_item_by_key("coin"),9)
	player_inventory.add_item(item_library.get_item_by_key("gem"),8)
	player_inventory.add_item(item_library.get_item_by_key("shoe"),13)
