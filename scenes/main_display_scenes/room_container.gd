extends CanvasLayer
class_name RoomContainer

@export var room_scene: PackedScene
var room: Room

func init_room(room_data) -> void:
	if room:
		room.queue_free()
		await room.tree_exited
	room = room_scene.instantiate()
	room.position = Vector2(242, 31)
	room.data = room_data
	room.clear_choices.connect(get_parent().choices_container.clear_options)
	add_child(room)
