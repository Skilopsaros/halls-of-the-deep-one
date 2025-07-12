extends Control
class_name Entity

@export var skin: Texture

var choices: Array[Dictionary] = []

signal entity_clicked

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var sprite = Sprite2D.new()
	sprite.texture = skin
	sprite.offset = Vector2i(0, 130)
	add_child(sprite)
	
	var area2d = Area2D.new()
	var collision = CollisionShape2D.new()
	collision.shape = RectangleShape2D.new()
	collision.shape.size = Vector2(240, 240)
	collision.position = Vector2(0, 130)
	area2d.add_child(collision)
	area2d.input_event.connect(_on_area_2d_input_event)
	add_child(area2d)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		print("emmiting signal")
		emit_signal("entity_clicked", choices)
