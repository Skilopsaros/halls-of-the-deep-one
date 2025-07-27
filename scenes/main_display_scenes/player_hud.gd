extends CanvasLayer
class_name PlayerHud

var rng = RandomNumberGenerator.new()
@onready var character := $Character
@onready var health_label := $Background/Health
@onready var insanity_label := $Background/Insanity
@onready var stats_values := {
	"power" = $Background/Stats/Power/Value,
	"agility" = $Background/Stats/Agility/Value,
	"perception" = $Background/Stats/Perception/Value,
	"occult" = $Background/Stats/Occult/Value
}

var character_scene: PackedScene = preload("res://scenes/character.tscn")

func _ready() -> void:
	character.init_character()

func _on_character_health_changed() -> void:
	health_label.text = str(character.current_health) + "/" + str(character.max_health)

func _on_character_insanity_changed() -> void:
	insanity_label.text = str(character.current_insanity) + "/" + str(character.max_insanity)

func _on_character_stats_changed() -> void:
	for stat in stats_values:
		stats_values[stat].text =  str(character.stats[stat])

func new_character() -> void:
	character.queue_free()
	await(character.tree_exited)
	character = character_scene.instantiate()
	character.health_changed.connect(_on_character_health_changed)
	character.insanity_changed.connect(_on_character_insanity_changed)
	character.stats_changed.connect(_on_character_stats_changed)
	for stat in character.stats:
		character.stats[stat] = randi_range(1,6) + randi_range(1,6) + randi_range(1,6)
	character.init_character()
	add_child(character)
	
