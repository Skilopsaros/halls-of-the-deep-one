extends Node

@onready var inventory = $InventoryLayer/Inventory

func _ready():
	inventory.add_item(Global.get_item_by_key("coin"),16)
	inventory.add_item(Global.get_item_by_key("gem"),8)
	inventory.add_item(Global.get_item_by_key("amulet"),12)
	inventory.add_item(Global.get_item_by_key("shoe"),17)
	
	inventory.remove_item(8)
