extends Control

var dragged_item = {}:
	set = set_dragged_item
	
@onready var item_icon = $ItemIcon

func set_dragged_item(item):
	dragged_item = item
	if dragged_item:
		item_icon.texture = load("res://assets/images/%s" % dragged_item.icon)
	else:
		item_icon.texture = null

func pick_up_item():
	pass
	
func put_down_item():
	pass
