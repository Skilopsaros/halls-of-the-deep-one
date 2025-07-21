extends TextureRect

@onready var background := $ItemSlotBackground
@onready var item_icon := $ItemIcon

@onready var shaders: Array[Shader] = [
	load("res://graphics/shaders/rotate0.gdshader"),
	load("res://graphics/shaders/rotate1.gdshader"),
	load("res://graphics/shaders/rotate2.gdshader"),
	load("res://graphics/shaders/rotate3.gdshader")
]

func display_item(item: Item):
	if item:
		item_icon.texture = item.texture
		item_icon.position = Vector2(10-item.offset*60,10)
		item_icon.rotation = PI/2*item.rotation
		item_icon.size = item.texture_size*2
		item_icon.pivot_offset = item_icon.size/2
		item_icon.position += item_icon.pivot_offset
		#item_icon.material.shader = shaders[item.rotation]
	else:
		item_icon.texture = null
		item_icon.size = Vector2i(40,40)
		item_icon.position = Vector2(10,10)
