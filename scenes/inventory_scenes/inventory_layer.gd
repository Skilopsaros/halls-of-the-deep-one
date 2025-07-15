extends CanvasLayer

@onready var drag_preview := $DragPreview
@onready var inventories := $Inventories
@onready var player_inventory := $Inventories/PlayerInventory

const Inventory := preload("res://scenes/inventory_scenes/inventory.gd")
const Starting_z_index: int = 2

@onready var inventory_view_order:Array[Inventory] = []

#### How to use:
# to generate a new inventory somewhere use this syntax
	#var chest = inventory_manager.add_inventory(5,3,"Chest")
# to add items to an existing inventory use this
	#chest.add_item(Global.get_item_by_key("coin"),0)

func _ready():
	for inventory in inventories.get_children():
		_initialize_inventory_interactivity(inventory)
		inventory_view_order.append(inventory)

func _on_inventory_slot_input(event: InputEvent, inventory:Inventory, slot_index:int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and drag_preview.dragged_item == {}:
			var item_index = inventory.occupancy_positions[slot_index]
			var clicked_item = inventory._find_item_by_index(item_index)
			if !clicked_item:
				return
			print(clicked_item.name)
			inventory.remove_item(item_index)
			drag_preview.dragged_item = clicked_item
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed and drag_preview.dragged_item != {}:
			var item_index = inventory.occupancy_positions[slot_index]
			if item_index != -1:
				return
			var sucess = inventory.add_item(drag_preview.dragged_item,slot_index)
			if sucess:
				drag_preview.dragged_item = {}

func move_inventory_to_foreground(inventory: Inventory) -> void:
	inventory_view_order.erase(inventory)
	inventory_view_order.append(inventory)
	for i in range(len(inventory_view_order)):
		inventory_view_order[i].z_index = Starting_z_index + 2*i

func add_inventory(cols: int, rows: int, title: String) -> Node2D:
	var new_inventory = Inventory.constructor(cols,rows,title)
	inventories.add_child(new_inventory)
	_initialize_inventory_interactivity(new_inventory)
	inventory_view_order.append(new_inventory)
	new_inventory.z_index = 2*len(inventory_view_order)
	drag_preview.z_index = 2*len(inventory_view_order)+2
	return new_inventory

func _initialize_inventory_interactivity(inventory:Inventory):
	var item_slots = inventory.foreground.get_children()
	for index in range(len(item_slots)):
		var item_slot = item_slots[index]
		item_slot.connect("gui_input", _on_inventory_slot_input.bind(inventory,index))
