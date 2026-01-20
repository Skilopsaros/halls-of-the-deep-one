extends CanvasLayer

@onready var log_line := $Background/Log/LineEdit
@onready var log_block := $Background/Log/TextEdit

func add_message_to_log(message:String) -> void:
	var last_message:String = log_line.text
	log_line.text = message
	
	var last_message_block:String = log_block.text
	log_block.text = "> " + last_message + "\n" + last_message_block
	
func clear_log() -> void:
	log_line.text = ""
	log_block.text = ""

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_log"):
		toggle_log()

func toggle_log() -> void:
	log_block.visible = !log_block.visible
	
