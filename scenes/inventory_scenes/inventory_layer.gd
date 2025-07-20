extends CanvasLayer

@onready var drag_preview := $DragPreview
@onready var inventories := $Inventories
@onready var player_inventory := $Inventories/PlayerInventory
@onready var player_weapon:= $Inventories/EquipmentWeapon
@onready var player_armor:= $Inventories/EquipmentArmor
@onready var player_accessory:= $Inventories/EquipmentAccessory

const Inventory := preload("res://scenes/inventory_scenes/inventory.gd")
const starting_z_index: int = 2

@onready var inventory_view_order:Array[Inventory] = []

#### How to use:
# to generate a new inventory somewhere use this syntax
	#var chest := inventory_manager.add_inventory(5,3,"Chest")
# to add items to an existing inventory use this
	#chest.add_item(Global.get_item_by_key("coin"),0)

func _ready() -> void:
	for inventory in inventories.get_children():
		_initialize_inventory_interactivity(inventory)
		inventory_view_order.append(inventory)
	
	_realign_pleayer_inventory_parts(40)
	
func _realign_pleayer_inventory_parts(player_UI_spacing: int) -> void:
	player_inventory.position = Vector2(player_UI_spacing,player_UI_spacing)
	player_weapon.position = Vector2(player_UI_spacing,player_UI_spacing*2+player_inventory.background_rect.size.y)
	player_armor.position = Vector2(player_UI_spacing*2+player_weapon.background_rect.size.x,player_UI_spacing*2+player_inventory.background_rect.size.y)
	player_accessory.position = Vector2(player_UI_spacing*3+player_weapon.background_rect.size.x+player_armor.background_rect.size.x,player_UI_spacing*2+player_inventory.background_rect.size.y)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_inventory"):
		player_inventory.visible = not player_inventory.visible
		player_weapon.visible = player_inventory.visible
		player_armor.visible = player_inventory.visible
		player_accessory.visible = player_inventory.visible

func _on_inventory_slot_input(event: InputEvent, inventory:Inventory, slot_index:int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and drag_preview.dragged_item == null:
			var item_index:int = inventory.occupancy_positions[slot_index]
			var clicked_item:Item = inventory._find_item_by_index(item_index)
			if !clicked_item:
				return
			print(clicked_item.name)
			inventory.remove_item(item_index)
			drag_preview.dragged_item = clicked_item
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed and drag_preview.dragged_item != null:
			var item_index:int = inventory.occupancy_positions[slot_index]
			if item_index != -1:
				# space is already occupied
				return
			var success:bool = inventory.add_item(drag_preview.dragged_item,slot_index)
			if success:
				drag_preview.dragged_item = null

func move_inventory_to_foreground(inventory: Inventory) -> void:
	inventory_view_order.erase(inventory)
	inventory_view_order.append(inventory)
	inventories.move_child(inventory,-1) # this makes sure the mouse click priorities are correct
	for i in range(len(inventory_view_order)):
		inventory_view_order[i].z_index = starting_z_index + 2*i

func add_inventory(cols: int, rows: int, title: String) -> Inventory:
	var new_inventory := Inventory.constructor(cols,rows,title)
	inventories.add_child(new_inventory)
	_initialize_inventory_interactivity(new_inventory)
	inventory_view_order.append(new_inventory)
	new_inventory.z_index = starting_z_index+2*len(inventory_view_order)-2
	drag_preview.z_index = starting_z_index+2*len(inventory_view_order)
	return new_inventory

func _initialize_inventory_interactivity(inventory:Inventory) -> void:
	var item_slots := inventory.foreground.get_children()
	for index in range(len(item_slots)):
		var item_slot := item_slots[index]
		item_slot.connect("gui_input", _on_inventory_slot_input.bind(inventory,index))
