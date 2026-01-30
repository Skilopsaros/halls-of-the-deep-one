extends CanvasLayer
class_name ChoicesContainer

@onready var grid_container := $Background/GridContainer

@export var option_scene : PackedScene

func clear_options() -> void:
	for n in grid_container.get_children():
		n.queue_free()

func add_options_from_options_list(options_list:Array[Dictionary], entity:Entity) -> void:
	clear_options()
	for o_dict in options_list:
		if "requirement" in o_dict:
			if not o_dict.requirement.call(entity):
				continue
		var option := option_scene.instantiate()
		option.entity = entity
		option._ready()
		option.init_from_dict(o_dict)
		grid_container.add_child(option)
