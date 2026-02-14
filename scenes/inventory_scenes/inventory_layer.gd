extends CanvasLayer

class_name InventoryManager

@onready var drag_preview := $DragPreview
@onready var hover_info := $HoverInfo
@onready var trash := $Trash
@onready var inventories := $Inventories
@onready var player_inventory := $Inventories/PlayerInventory
@onready var player_weapon:= $Inventories/EquipmentWeapon
@onready var player_armour:= $Inventories/EquipmentArmour
@onready var player_accessory:= $Inventories/EquipmentAccessory
@onready var entity_inventory:= $Inventories/EntityInventory
@onready var input_inventory:= $Inventories/InputInventory

@onready var room_cover_rect := $Decorations/RoomCover
@onready var close_button := $Decorations/CloseButton
@onready var take_all_button := $Decorations/TakeAllButton

# this desicion is completely arbitrary right now, change if needed
const max_temp_inventory_size := Vector2i(7,7)

#### How to use:
# to generate a new inventory somewhere use this syntax
	#var chest := inventory_manager.add_inventory(5,3,"Chest")
# to add items to an existing inventory use this
	#chest.add_item(ItemManager.get_item_by_name("coin"),0)

func get_inventory_tags() -> Dictionary[String, Array]:
	var dict:Dictionary[String, Array] = {}
	dict["inventory"] = player_inventory.get_contained_tags()
	dict["weapon"] = player_weapon.get_contained_tags()
	dict["armour"] = player_armour.get_contained_tags()
	dict["accessory"] = player_accessory.get_contained_tags()
	return dict

func _ready() -> void:
	#player_inventory.top_bar.visible = false'
	for inventory in inventories.get_children():
		_initialize_inventory_interactivity(inventory)
	trash.connect("gui_input", _trash_item)

func toggle_inventory_visibility() -> void:
	if drag_preview.dragged_item:
		return
	if not drag_preview.dragged_item:
		self.propagate_call("set_visible", [not self.visible])
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_inventory"):
		pass

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
			inventory.remove_item(clicked_item)
			drag_preview.dragged_item = clicked_item
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed and drag_preview.dragged_item != null:
			var item:ItemObject = drag_preview.dragged_item
			var success:bool = inventory.add_item(item,coordinate)
			if success:
				drag_preview.dragged_item = null
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and drag_preview.dragged_item == null:
			if not coordinate in inventory.occupancy_dict.keys():
				return
			var clicked_item:ItemObject = inventory.occupancy_dict[coordinate]
			if !clicked_item:
				return
			if !clicked_item.inventory:
				return
			clicked_item.inventory.visible = not clicked_item.inventory.visible
			clicked_item.inventory.position = clicked_item.inventory.get_global_mouse_position()

func move_inventory_to_foreground(inventory: Inventory) -> void:
	inventories.move_child(inventory,-1) # this makes sure the mouse click priorities are correct

func add_inventory(cols: int, rows: int, title: String = "", closable:bool = true, minimizable:bool = false, movable:bool = false, initial_active_list:Array[Vector2i]=[]) -> Inventory:
	# this should work tecnically but maybe it's not helpful
	var new_inventory: Inventory = Inventory.constructor(cols,rows,title,closable,minimizable,movable,initial_active_list)
	inventories.add_child(new_inventory)
	_initialize_inventory_interactivity(new_inventory)
	new_inventory.position = Vector2i(100,100)
	return new_inventory

func show_input_inventory(cols: int, rows: int, required_tags:Dictionary[Enums.item_tags, int], filters:Array[Enums.item_tags], title: String = "") -> Inventory:
	for item in input_inventory.items.get_children():
		input_inventory.destroy_item(item)
	var initial_active_list:Array[Vector2i] = []
	for i in range(cols):
		for j in range(rows):
			initial_active_list.append(Vector2i(i,j))
	input_inventory.filters = filters
	input_inventory.title = title
	input_inventory.required_tags = required_tags
	input_inventory.show()
	return input_inventory

	
func display_hidden_inventory_with_items(item_list:Array[String]) -> void:
	var inventory:Inventory = entity_inventory
	
	var item_object_list:Array[ItemObject]
	var full_content_size:int = 0
	for key:String in item_list: # generate all item objects
		var new_item = ItemManager.get_item_by_name(key)
		item_object_list.append(new_item)
		full_content_size += len(new_item.occupancy)
	
	# sort the items by size, larger items are porbably harder to place and we want to put them in first
	item_object_list.sort_custom(ItemObject.item_size_sorter)

	#clear the inventory
	for item in inventory.items.get_children():
		inventory.destroy_item(item)
	
	var columns_to_put:int = 1
	var rows_to_put:int = 1
	if len(item_object_list) == 1:
		columns_to_put = item_object_list[0].bounding_box.x
		rows_to_put = item_object_list[0].bounding_box.y
		inventory.set_active_rectangle(columns_to_put,rows_to_put)
	
	columns_to_put = floor(sqrt(full_content_size))
	rows_to_put = floor(sqrt(full_content_size))
	inventory.set_active_rectangle(columns_to_put,rows_to_put)
	for item_object in item_object_list:
		var success:bool = false
		while not success:
			success = inventory.add_item_at_first_possible_position(item_object) != Vector2i(-1,-1)
			if not success:
				if columns_to_put > rows_to_put:
					rows_to_put += 1
				else:
					columns_to_put += 1
				if columns_to_put > inventory.cols and rows_to_put > inventory.rows:
					inventory.visible = true
					return # we failed
				inventory.set_active_rectangle(columns_to_put,rows_to_put)
	inventory.visible = true
	return

func add_inventory_from_item_list(item_list:Array[String],title:String) -> void:
	if len(item_list) == 0:
		return
	# define max temp inventory size
	var item_object_list:Array[ItemObject]
	var full_content_size:int = 0
	for key:String in item_list: # generate all item objects
		var new_item = ItemManager.get_item_by_name(key)
		item_object_list.append(new_item)
		full_content_size += len(new_item.occupancy)
	
	var columns_to_put:int = 1
	var rows_to_put:int = 1
	var new_inventory:Inventory
	if len(item_object_list) == 1: # only one item to place, let's take a shortcut
		columns_to_put = item_object_list[0].bounding_box.x
		rows_to_put = item_object_list[0].bounding_box.y
		new_inventory = add_inventory(columns_to_put,rows_to_put,title,true,false,true,[])
		new_inventory.add_item_at_first_possible_position(item_object_list[0])
		return
	
	columns_to_put = floor(sqrt(full_content_size))
	rows_to_put = floor(sqrt(full_content_size))
	
	while true:
		new_inventory = add_inventory(columns_to_put,rows_to_put,title,true,false,true,[])
		var success:bool = true
		for item_object in item_object_list:
			success = success and (new_inventory.add_item_at_first_possible_position(item_object) != Vector2i(-1,-1))
		if success:
			return
		remove_inventory(new_inventory)
		if columns_to_put > rows_to_put:
			rows_to_put += 1
		else:
			columns_to_put += 1
		
func remove_inventory(inventory: Inventory) -> void:
	for item in inventory.items.get_children():
		inventory.destroy_item(item)
	inventory.queue_free()

func _initialize_inventory_interactivity(inventory:Inventory) -> void:
	inventory.connect("cell_clicked", _on_inventory_slot_input)
	inventory.connect("inventory_changed", _on_inventory_changed)
	inventory.connect("inventory_closing", remove_inventory)
	inventory.connect("item_hover_info_activated",_on_hover_info_activated)
	inventory.connect("item_hover_info_deactivated",_on_hover_info_deactivated)
	inventory.connect("inventory_visibility_changed",_on_inventory_visibility_changed)
	
func _on_hover_info_activated(item:ItemObject) -> void:
	hover_info.display_item(item)

func _on_hover_info_deactivated() -> void:
	hover_info.visible = false
	hover_info.displayed_item = null
	
func _on_inventory_visibility_changed(inventory:Inventory,new_visibiltiy_state:bool) -> void:
	if inventory in [input_inventory,entity_inventory]:
		room_cover_rect.visible = new_visibiltiy_state
		close_button.visible = new_visibiltiy_state
		if inventory == entity_inventory:
			take_all_button.visible = new_visibiltiy_state

func _on_close_button_pressed() -> void:
	assert(input_inventory.visible or entity_inventory.visible, "No closable inventory is visible")
	var active_inventory:Inventory;
	if input_inventory.visible:
		active_inventory = input_inventory
	else:
		active_inventory = entity_inventory
	
	active_inventory.hide()

func _on_take_all_button_pressed() -> void:
	assert(entity_inventory.visible, "Entity inventory isn't visible, nothing to take all from")
	var items_to_place:Array[Node] = entity_inventory.items.get_children()
	items_to_place.sort_custom(ItemObject.item_size_sorter)

	for item in items_to_place:
		var old_item_position:Vector2i = item.location
		entity_inventory.remove_item(item)
		self.add_child(item)
		var position:Vector2i = player_inventory.add_item_at_first_possible_position(item)
		if position == Vector2i(-1,-1):
			entity_inventory.add_item(item,old_item_position)
	
	if len(entity_inventory.items.get_children()) == 0:
		entity_inventory.hide()
