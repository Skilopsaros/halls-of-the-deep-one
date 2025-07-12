extends Node

@onready var choices_container = $ChoisesContainer

func _on_entity_clicked(options_list:Array[Dictionary]) -> void:
	print("on entity clicked")
	print(choices_container)
	choices_container.add_options_from_options_list(options_list)
