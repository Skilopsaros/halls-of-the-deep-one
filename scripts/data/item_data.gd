extends Resource
class_name Item

@export var name: String # in code reference name
@export var title: String # in game display name
@export var texture: Texture
@export var alternative_textures: Array[Texture]
@export_multiline var occupancy_matrix: String
@export var tags: Array[Enums.item_tags]
@export_group("Equip stat modifiers")
@export var stat_modifiers: Dictionary[Enums.stats, int] = {
	Enums.stats.power:0,
	Enums.stats.agility:0,
	Enums.stats.perception:0,
	Enums.stats.occult:0
}
@export var max_health_modifier: int = 0
@export var max_insanity_modifier: int = 0
@export_group("Various")
@export var value: int
@export var movable: bool = true
@export_multiline var flavour_text:String
