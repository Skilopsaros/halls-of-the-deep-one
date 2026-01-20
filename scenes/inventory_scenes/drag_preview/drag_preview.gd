extends Control

var dragged_item: Item = null:
	set = set_dragged_item
	
@onready var item_icon := $ItemIcon

func set_dragged_item(item: Item) -> void:
	dragged_item = item
	_update_visuals()

func _update_visuals() -> void:
	if dragged_item:
		item_icon.texture = dragged_item.texture
		item_icon.rotation = PI/2*dragged_item.rotation
		item_icon.position = Vector2(-20,-20) + dragged_item.draw_offset
	else:
		item_icon.texture = null

func _process(_delta: float) -> void:
	position = get_global_mouse_position()
	if Input.is_action_just_pressed("rotate_item"):
		if dragged_item:
			dragged_item.rotate()
			_update_visuals()
