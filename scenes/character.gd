extends Node

class_name Character

signal health_changed
signal insanity_changed
signal died
signal insane

@export var max_health: int = 20
@export var max_insanity: int = 20
@export var power: int = 10
@export var agility: int = 10
@export var perception: int = 10
@export var occult: int = 10

var current_health: int
var current_insanity: int = 0

func _ready() -> void:
	current_health = max_health

func take_damage(d:int):
	current_health -= d
	emit_signal("health_changed")
	if current_health <= 0:
		emit_signal("died")

func heal_damage(d:int):
	current_health += d
	if current_health >= max_health:
		current_health = max_health
	emit_signal("health_changed")

func take_insanity(d:int):
	current_insanity += d
	emit_signal("insanity_changed")
	if current_insanity >= max_insanity:
		emit_signal("insane")
		
func heal_insanity(d:int):
	current_insanity -= d
	if current_insanity < 0:
		current_insanity = 0
	emit_signal("insanity_changed")

func _to_string() -> String:
	var text:String = "----------\n"
	text += "Health: %s/%s\n" % [current_health,max_health]
	text += "Insanity: %s/%s\n" % [current_insanity,max_insanity]
	text += "Power: %s\n" % power
	text += "Agility: %s\n" % agility
	text += "Perception: %s\n" % perception
	text += "Occult: %s" % occult
	return text
	
