extends CanvasLayer

@onready var drag_preview := $DragPreview
@onready var inventories := $Inventories
@onready var player_inventory := $Inventories/PlayerInventory

const Inventory = preload("res://scenes/inventory_scenes/inventory.gd")

func add_inventory(cols: int, rows: int) -> Node2D:
	var new_inventory = Inventory.constructor(cols,rows)
	inventories.add_child(new_inventory)
	return new_inventory
