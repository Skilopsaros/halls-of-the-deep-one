extends ColorRect

@onready var item_icon = $ItemIcon

func display_item(item):
	if item:
		item_icon.texture = load("res://graphics/items/%s" % item.icon)
		item_icon.position = Vector2(5-item.offset*60,5)
	else:
		item_icon.texture = null
