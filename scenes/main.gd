extends Node

@onready var inventory = $InventoryLayer/Inventory

func _ready():
	inventory.set_item(Global.get_item_by_key("coin"),16)
	inventory.set_item(Global.get_item_by_key("gem"),8)
	inventory.set_item(Global.get_item_by_key("amulet"),12)
	inventory.set_item(Global.get_item_by_key("shoe"),17)
	
