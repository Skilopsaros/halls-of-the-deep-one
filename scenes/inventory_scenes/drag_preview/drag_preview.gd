extends Control

@onready var dragged_item_parent:Node = $DraggedItemParent

var dragged_item: ItemObject = null:
	set = set_dragged_item
	
@onready var item_icon := $ItemIcon

func set_dragged_item(item: ItemObject) -> void:
	dragged_item = item
	if not dragged_item:
		for child in dragged_item_parent.get_children():
			dragged_item_parent.remove_child(child)
	else:
		dragged_item_parent.add_child(dragged_item)

func _process(_delta: float) -> void:
	if not dragged_item:
		return
	dragged_item.position = get_global_mouse_position()
	if Input.is_action_just_pressed("rotate_item"):
		if dragged_item:
			dragged_item.rotate_90()
