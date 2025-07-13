extends CanvasLayer

@onready var drag_preview := $DragPreview
@onready var inventories := $Inventories
@onready var player_inventory := $Inventories/PlayerInventory

const Inventory = preload("res://scenes/inventory_scenes/inventory.gd")

func _ready():
	for inventory in inventories.get_children():
		_initialize_inventory(inventory)
#
func _on_inventory_slot_input(event: InputEvent, inventory:Inventory, index:int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and drag_preview.dragged_item == {}:
			var inx = inventory.occupancy_positions[index]
			var clicked_item = inventory._find_item_by_index(inx)
			if clicked_item[0] == -1:
				return
			inventory.remove_item(inx)
			drag_preview.dragged_item = clicked_item[1]
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed and drag_preview.dragged_item != {}:
			var inx = inventory.occupancy_positions[index]
			if inx != -1:
				return
			var sucess = inventory.add_item(drag_preview.dragged_item,index)
			if sucess:
				drag_preview.dragged_item = {}
			

func add_inventory(cols: int, rows: int, title: String) -> Node2D:
	var new_inventory = Inventory.constructor(cols,rows,title)
	inventories.add_child(new_inventory)
	
	_initialize_inventory(new_inventory)
	
	return new_inventory

func _initialize_inventory(inventory:Inventory):
	var item_slots = inventory.background.get_children()
	for index in range(len(item_slots)):
		var item_slot = item_slots[index]
		item_slot.connect("gui_input", _on_inventory_slot_input.bind(inventory,index))
