extends Control
class_name Entity

@export var skin: Texture

func _ready():
	var sprite = Sprite2D.new()
	sprite.texture = skin
	sprite.offset = Vector2i(0, 130)
	add_child(sprite)
