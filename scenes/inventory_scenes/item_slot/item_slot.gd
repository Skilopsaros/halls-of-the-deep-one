extends TextureRect

@onready var background := $ItemSlotBackground
@onready var item_icon := $ItemIcon

func display_item(item: Item):
	if item:
		item_icon.texture = item.texture
		item_icon.rotation = PI/2*item.rotation
		item_icon.position = Vector2(10,10)
		match item.rotation:
			0:
				pass
			1:
				item_icon.position += Vector2((item.bounding_box.y)*40,0)
				item_icon.position += Vector2((item.bounding_box.y-1)*20,0)
			2:
				item_icon.position += Vector2((item.bounding_box.y)*40,(item.bounding_box.x)*40)
				item_icon.position += Vector2((item.bounding_box.y-1)*20,(item.bounding_box.x-1)*20)
			3:
				item_icon.position += Vector2(0,(item.bounding_box.x)*40)
				item_icon.position += Vector2(0,(item.bounding_box.x-1)*20)
		item_icon.position -= Vector2(item.offset*60,0)
	else:
		item_icon.texture = null
