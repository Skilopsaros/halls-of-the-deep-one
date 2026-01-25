extends CanvasLayer

class_name InventoryManager

@onready var drag_preview := $DragPreview
@onready var trash := $Trash
@onready var inventories := $Inventories
@onready var player_inventory := $Inventories/PlayerInventory
@onready var player_weapon:= $Inventories/EquipmentWeapon
@onready var player_armour:= $Inventories/EquipmentArmour
@onready var player_accessory:= $Inventories/EquipmentAccessory

const starting_z_index: int = 2
const player_UI_spacing: int = 40

@onready var inventory_view_order:Array[Inventory] = []

#### How to use:
# to generate a new inventory somewhere use this syntax
	#var chest := inventory_manager.add_inventory(5,3,"Chest")
# to add items to an existing inventory use this
	#chest.add_item(ItemManager.get_item_by_name("coin"),0)

func get_inventory_tags() -> Dictionary:
	var dict:Dictionary = {}
	dict["inventory"] = player_inventory.get_contained_tags()
	dict["weapon"] = player_weapon.get_contained_tags()
	dict["armour"] = player_armour.get_contained_tags()
	dict["accessory"] = player_accessory.get_contained_tags()
	return dict

func _ready() -> void:
	for inventory in inventories.get_children():
		_initialize_inventory_interactivity(inventory)
		inventory_view_order.append(inventory)
		#inventory.inventory_changed.connect(_on_inventory_changed)
	trash.connect("gui_input", _trash_item)
	self.propagate_call("set_visible", [false])

func toggle_inventory_visibility() -> void:
	self.propagate_call("set_visible", [not self.visible])
	# this is really strange but will be gone after the UI overhaul anyways
	#player_inventory.visible = not player_inventory.visible
	#player_weapon.visible = player_inventory.visible
	#player_armour.visible = player_inventory.visible
	#player_accessory.visible = player_inventory.visible
	#trash.visible = player_inventory.visible
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_inventory"):
		toggle_inventory_visibility()

func _on_inventory_changed(inventory:Inventory, item:ItemObject, event_cause:String)->void:
	if inventory == player_inventory:
		var total_value: int = inventory.get_total_value()
		player_inventory.title_label.text = str(total_value)+" €"
	
	if inventory in [player_weapon,player_armour,player_accessory]:
		var character: Node = get_node("/root/Main/PlayerHud").character
		match event_cause:
			"add":
				item._on_equip(character)
			"remove":
				item._on_unequip(character)

func _trash_item(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if 0 < event.position.x and event.position.x < 30 and 0 < event.position.y and event.position.y < 30:
				var to_delete_item:ItemObject = drag_preview.dragged_item
				if to_delete_item.data is ContainerItem:
					remove_inventory(to_delete_item.data.inventory)
				drag_preview.dragged_item = null
				to_delete_item.queue_free()
				
func _on_inventory_slot_input(event: InputEvent, coordinate:Vector2i, inventory:Inventory) -> void:

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and drag_preview.dragged_item == null:
			if not coordinate in inventory.occupancy_dict.keys():
				return
			var clicked_item:ItemObject = inventory.occupancy_dict[coordinate]
			if !clicked_item:
				return
			print(clicked_item.name)
			inventory.remove_item(clicked_item)
			drag_preview.dragged_item = clicked_item
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed and drag_preview.dragged_item != null:
			var success:bool = inventory.add_item(drag_preview.dragged_item,coordinate)
			if success:
				drag_preview.dragged_item = null
		#elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and drag_preview.dragged_item == null:
			#var item_index:int = inventory.occupancy_positions[slot_index]
			#var clicked_item:Item = inventory._find_item_by_index(item_index)
			#if !clicked_item:
				#return
			#if not clicked_item is ContainerItem:
				#return
			#clicked_item.inventory.visible = not clicked_item.inventory.visible

func move_inventory_to_foreground(inventory: Inventory) -> void:
	inventory_view_order.erase(inventory)
	inventory_view_order.append(inventory)
	inventories.move_child(inventory,-1) # this makes sure the mouse click priorities are correct
	_update_view_order()

func add_inventory(cols: int, rows: int, title: String, closable:bool = true, minimizable:bool = false) -> Inventory:
	# this should work tecnically but maybe it's not helpful
	var new_inventory := Inventory.constructor(cols,rows,title)
	inventories.add_child(new_inventory)
	_initialize_inventory_interactivity(new_inventory)
	inventory_view_order.append(new_inventory)
	new_inventory.z_index = starting_z_index+2*len(inventory_view_order)-2
	drag_preview.z_index = starting_z_index+2*len(inventory_view_order)
	return new_inventory

func _update_view_order() -> void:
	for i in range(len(inventory_view_order)):
		if inventory_view_order[i] != null: # no clue why this is even necessary
			inventory_view_order[i].z_index = starting_z_index + 2*i
	drag_preview.z_index = starting_z_index+2*len(inventory_view_order)

func remove_inventory(inventory: Inventory) -> void:
	inventory_view_order.erase(inventory)
	inventory.queue_free()
	_update_view_order()

func _initialize_inventory_interactivity(inventory:Inventory) -> void:
	inventory.connect("cell_clicked", _on_inventory_slot_input)
	inventory.connect("inventory_changed", _on_inventory_changed)
