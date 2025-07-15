extends Area2D

@onready var shape := $CollisionShape2D

func set_size(size: Vector2):
	shape.shape.size = size
	
