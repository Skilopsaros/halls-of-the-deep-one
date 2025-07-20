extends TextureRect

@onready var background := $ItemSlotBackground
@onready var item_icon := $ItemIcon

func display_item(item: Item):
	if item:
		item_icon.texture = item.texture
		item_icon.position = Vector2(10-item.offset*60,10)
	else:
		item_icon.texture = null
