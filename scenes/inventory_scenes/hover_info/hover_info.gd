extends Control

@onready var title_label := $TitleLabel
@onready var text_label := $TextLabel
@onready var flavour_label := $FlavourLabel

func _ready() -> void:
	visible = false

func display_item_data(item:Item) -> void:
	var text_to_display: String 
	if item.title != "":
		title_label.text = "[b]" + item.title 
	else:
		title_label.text = "[b]" + item.name
		
	for key in item.stat_modifiers.keys():
		text_to_display += key + ": " + str(item.stat_modifiers[key]) + "\n"
	text_to_display += "\nvalue: " + str(item.value)
	text_label.text = text_to_display
	
	flavour_label.text = "[i]" + item.flavour_text
