extends CanvasLayer

@onready var drag_preview := $DragPreview
@onready var inventories := $Inventories
@onready var player_inventory := $Inventories/PlayerInventory

const Inventory = preload("res://scenes/inventory_scenes/inventory.gd")

#func _ready():
	#player_inventory.background_rect.connect("gui_input", _on_inventoryBackground_input.bind(player_inventory))
#
#func _on_inventoryBackground_input(event: InputEvent, inventory:Inventory) -> void:
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#inventory.hide()

func add_inventory(cols: int, rows: int) -> Node2D:
	var new_inventory = Inventory.constructor(cols,rows)
	inventories.add_child(new_inventory)
	return new_inventory
