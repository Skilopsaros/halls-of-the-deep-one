extends Control

var dragged_item = {}:
	set = set_dragged_item
	
@onready var item_icon = $ItemIcon

func set_dragged_item(item) -> void:
	dragged_item = item
	if dragged_item:
		item_icon.texture = load("res://graphics/items/%s" % dragged_item.icon)
		item_icon.position.x = -20-dragged_item.offset*60
		item_icon.position.y = -20
	else:
		item_icon.texture = null
		item_icon.size = Vector2(0,0)

func _process(delta: float) -> void:
	position = get_global_mouse_position()

func pick_up_item(item) -> bool:
	if dragged_item != {}:
		return false
	else:
		dragged_item = item
		return true
	
func put_down_item() -> Dictionary:
	var previous_item = dragged_item
	dragged_item = {}
	return previous_item
