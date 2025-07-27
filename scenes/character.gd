extends Node

class_name Character

signal health_changed
signal insanity_changed
signal stats_changed
signal died
signal insane

@export var max_health: int = 5
@export var max_insanity: int = 5
@export var stats: Dictionary[String, int] ={
	"power" = 12,
	"agility" = 8,
	"perception" = 9,
	"occult" = 11
}

var current_health: int
var current_insanity: int = 0

func _ready() -> void:
	pass

func init_character() -> void:
	current_health = max_health
	current_insanity = 0
	emit_signal("insanity_changed")
	emit_signal("health_changed")
	emit_signal("stats_changed")

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

func change_stat(stat:String, change:int):
	stats[stat] += change
	emit_signal("stats_changed")
	
func set_stat(stat:String, value:int):
	stats[stat] = value
	emit_signal("stats_changed")
	
