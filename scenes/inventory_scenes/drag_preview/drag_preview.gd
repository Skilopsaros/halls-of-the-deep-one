extends Control

var dragged_item: Item = null:
	set = set_dragged_item
	
@onready var item_icon := $ItemIcon

func set_dragged_item(item: Item) -> void:
	dragged_item = item
	_update_visuals()S

func _update_visuals() -> void:
	if dragged_item:
		item_icon.texture = dragged_item.texture
		item_icon.rotation = PI/2*dragged_item.rotation
		item_icon.position = Vector2(-20,-20)
		match dragged_item.rotation:
			0:
				pass
			1:
				item_icon.position += Vector2((dragged_item.bounding_box.y)*40,0)
				item_icon.position += Vector2((dragged_item.bounding_box.y-1)*20,0)
			2:
				item_icon.position += Vector2((dragged_item.bounding_box.y)*40,(dragged_item.bounding_box.x)*40)
				item_icon.position += Vector2((dragged_item.bounding_box.y-1)*20,(dragged_item.bounding_box.x-1)*20)
			3:
				item_icon.position += Vector2(0,(dragged_item.bounding_box.x)*40)
				item_icon.position += Vector2(0,(dragged_item.bounding_box.x-1)*20)
		item_icon.position -= Vector2(dragged_item.offset*60,0)
	else:
		item_icon.texture = null

func _process(delta: float) -> void:
	position = get_global_mouse_position()
	if Input.is_action_just_pressed("rotate_item"):
		if dragged_item:
			dragged_item.rotate()
			_update_visuals()

func pick_up_item(item: Item) -> bool:
	if !dragged_item:
		return false
	else:
		dragged_item = item
		return true
	
func put_down_item() -> Item:
	var previous_item: Item = dragged_item
	dragged_item = null
	return previous_item
