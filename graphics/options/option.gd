extends Control
class_name Option

@onready var title := $OptionTitle
@onready var text := $OptionText
 
var action: Callable = null_action

func _ready():
	print(title)
	print(text)

func init_from_dict(init_dict:Dictionary) -> void:
	title.text = init_dict["title"]
	text.text = init_dict["text"]
	action = init_dict["action"]

func perform_action() -> void:
	action.call()

func null_action() -> void:
	print("null_action")


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		perform_action()
