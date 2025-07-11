extends ColorRect

@onready var item_icon = $ItemIcon

func display_item(item):
	if item:
		item_icon.texture = load("res://graphics/items/%s" % item.icon)
	else:
		item_icon.texture = null
