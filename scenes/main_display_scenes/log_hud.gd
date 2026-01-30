extends CanvasLayer

@onready var messages_container: VBoxContainer = $MessagesContainer

var max_y_size: int = 197

func add_message(message:String):
	var old_first_message:Label = messages_container.get_child(0)
	old_first_message.add_theme_color_override("font_color", "#e9e9e9")
	old_first_message.add_theme_font_size_override("font_size", 15)
	var new_first_message:Label = Label.new()
	new_first_message.text = message
	messages_container.add_child(new_first_message)
	messages_container.move_child(new_first_message, 0)
	trim_messages()

func trim_messages():
	for message in messages_container.get_children():
		if message.position.y > max_y_size:
			message.queue_free()
			print("HERE")
