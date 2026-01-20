extends Control
class_name Entity

@export var data: EntityData

@onready var skin: Texture = data.skin
@onready var choices: Array[Dictionary] = data.get_choices()
@onready var outline_material = preload("res://graphics/shaders/Outlined.tres")

var sprite: Sprite2D
var index: int

signal clear_entity

signal entity_clicked

func _ready():
	custom_minimum_size = Vector2(82,130)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	sprite = Sprite2D.new()
	sprite.texture = skin
	sprite.scale = Vector2(2,2)
	sprite.offset = Vector2i(20, 65)
	sprite.material = outline_material
	add_child(sprite)
	
	var area2d := Area2D.new()
	var collision := CollisionShape2D.new()
	collision.shape = RectangleShape2D.new()
	collision.shape.size = Vector2(160, 260)
	collision.position = Vector2(42, 130)
	area2d.add_child(collision)
	area2d.input_event.connect(_on_area_2d_input_event)
	add_child(area2d)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("entity_clicked", choices, self)

func clear_self():
	emit_signal("clear_entity", index)
