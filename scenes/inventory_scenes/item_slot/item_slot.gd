extends TextureRect

@onready var item_icon := $ItemIcon

func display_item(item: Item):
	if item:
		item_icon.texture = item.texture
		item_icon.rotation = PI/2*item.rotation
		item_icon.position = Vector2(10,10)
		item_icon.position += item.draw_offset
	else:
		item_icon.texture = null
