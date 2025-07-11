extends Node

@onready var inventory = $InventoryLayer/Inventory

func _ready():
	inventory.set_item(Global.get_item_by_key("coin"),5)
	inventory.set_item(Global.get_item_by_key("gem"),8)
	
