extends Node

class_name Character

signal health_changed
signal insanity_changed
signal stats_changed
signal died
signal insane

@export var max_health: int = 50
@export var max_insanity: int = 50
@export var stats: Dictionary[Enums.stats, int] = {
	Enums.stats.power:0,
	Enums.stats.agility:0,
	Enums.stats.perception:0,
	Enums.stats.occult:0
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

func take_damage(d:int) -> void:
	current_health -= d
	emit_signal("health_changed")
	if current_health <= 0:
		emit_signal("died")

func heal_damage(d:int) -> void:
	current_health += d
	if current_health >= max_health:
		current_health = max_health
	emit_signal("health_changed")

func take_insanity(d:int) -> void:
	current_insanity += d
	emit_signal("insanity_changed")
	if current_insanity >= max_insanity:
		emit_signal("insane")
		
func heal_insanity(d:int) -> void:
	current_insanity -= d
	if current_insanity < 0:
		current_insanity = 0
	emit_signal("insanity_changed")

func change_stat(stat:Enums.stats, change:int) -> void:
	stats[stat] += change
	emit_signal("stats_changed")
	
func set_stat(stat:Enums.stats, value:int) -> void:
	stats[stat] = value
	emit_signal("stats_changed")

func get_starting_inventory_active_list(inv_size:int) -> Array[Vector2i]:
	var agent_position := Vector2i(3,3)
	var enabled:Array[Vector2i] = [
		Vector2i(2,2),Vector2i(2,3),Vector2i(2,4),
		Vector2i(3,2),Vector2i(3,3),Vector2i(3,4),
		Vector2i(4,2),Vector2i(4,3),Vector2i(4,4),
		]
	var directions = [Vector2i(0,-1),Vector2i(0,1),Vector2i(1,0),Vector2i(-1,0)]
	while len(enabled)<inv_size:
		var new_direction = directions[randi()%len(directions)]
		agent_position += new_direction
		if agent_position.x>=7 or agent_position.y>=7 or agent_position.y<0 or agent_position.x<0:
			agent_position = Vector2i(3,3)
		if agent_position not in enabled:
			enabled.append(agent_position)
	print(enabled)
	return(enabled)
		
