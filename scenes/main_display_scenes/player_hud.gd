extends CanvasLayer
class_name PlayerHud

@onready var character := $Character
@onready var health_label := $Background/Health
@onready var insanity_label := $Background/Insanity

func _ready() -> void:
	character.init_character()

func _on_character_health_changed() -> void:
	health_label.text = str(character.current_health) + "/" + str(character.max_health)


func _on_character_insanity_changed() -> void:
	insanity_label.text = str(character.current_insanity) + "/" + str(character.max_insanity)
