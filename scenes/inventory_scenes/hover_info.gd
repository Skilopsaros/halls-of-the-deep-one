extends Control
class_name HoverInfo

@onready var title_label := $VBoxContainer/TitleLabel
@onready var text_label := $VBoxContainer/Container/TextLabel
@onready var flavour_label := $VBoxContainer/FlavourLabel

var displayed_item:ItemObject = null

func _ready() -> void:
	visible = false

var visibility_counter:float = 0

func _process(delta: float) -> void:
	if displayed_item:
		visibility_counter += delta
		if visibility_counter > 0.5 and not visible:
			position = get_global_mouse_position() + Vector2(10,10)
			visible = true
	
func display_item(item_object:ItemObject) -> void:
	displayed_item = item_object
	var item = item_object.data
	var text_to_display: String = ""
	if item.title != "":
		title_label.text = "[b]" + item.title 
	else:
		title_label.text = "[b]" + item.name
		
	for key in item.stat_modifiers.keys():
		if item.stat_modifiers[key] != 0:
			text_to_display += Enums.stats.keys()[key] + ": " + str(item.stat_modifiers[key]) + "\n"
	text_to_display += "value: " + str(item.value) + "\n\n"
	for i in range(len(item.tags)):
		text_to_display +=  Enums.item_tags.keys()[item.tags[i]]
		if i != len(item.tags)-1:
			text_to_display += ", "
	text_label.text = text_to_display
	
	flavour_label.text = "[i]" + item.flavour_text
	visibility_counter = 0
