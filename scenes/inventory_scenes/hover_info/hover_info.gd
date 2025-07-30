extends Control

@onready var label := $TextLabel
@export var text:String = ""

func _ready() -> void:
	visible = false

func display(text_to_display:String) -> void:
	text = text_to_display
	label.text = text
	visible = true

func display_item_data(item:Item) -> void:
	var text_to_display: String = ""
	for key in item.stat_modifiers.keys():
		text_to_display += key + ": " + str(item.stat_modifiers[key]) + "\n"
	text_to_display += "\nvalue: " + str(item.value)
	display(text_to_display)
