extends Control

@onready var label := $TextLabel
@export var text:String = ""
var displayed_item:Item

func _ready() -> void:
	visible = false

func display(text_to_display:String) -> void:
	text = text_to_display
	label.text = text
	visible = true

func display_item_data(item:Item) -> void:
	displayed_item = item
	var text_to_display: String 
	if item.title != "":
		text_to_display = "-" + item.title + "-\n"
	else:
		text_to_display = "-" + item.name + "-\n"
		
	for key in item.stat_modifiers.keys():
		text_to_display += key + ": " + str(item.stat_modifiers[key]) + "\n"
	text_to_display += "\nvalue: " + str(item.value)
	display(text_to_display)
