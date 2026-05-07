#Has all the info needed for the ability panel & clicker to set abilities
extends Resource
class_name AbilityResource

const total_ability_count : int = 14

#For ability setting
@export var ability_name : String = "Basic Shot"
@export var ability_num : int = 0
@export var ability_max : float = 5
@export var ability_damage : float = 3

@export var rarity : int = 0
const rarity_common_color : Color = Color(1.0, 1.0, 1.0, 1.0)
const rarity_uncommon_color : Color = Color(0.457, 1.0, 0.441, 1.0)
const rarity_rare_color : Color = Color(0.587, 1.0, 0.997, 1.0)
const rarity_epic_color : Color = Color(0.679, 0.424, 0.993, 1.0)
const rarity_legendary_color : Color = Color(0.936, 0.693, 0.255, 1.0)
const rarity_common_scaling : float = 1
const rarity_uncommon_scaling : float = 1.25
const rarity_rare_scaling : float = 1.5
const rarity_epic_scaling : float = 1.75
const rarity_legendary_scaling : float = 2

#For pickups
@export var damage_level : int = 0
@export var power_level : int = 0
@export var clicker_level : int = 0
@export var length_level : int = 0
@export var description : String = "Default"
@export var icon : CompressedTexture2D = preload("res://sprites/icons/Icon_bullet16x16.png")

func set_rarity() -> void:
	if rarity == 0:
		ability_damage *= rarity_common_scaling
	if rarity == 1:
		ability_damage *= rarity_uncommon_scaling
	if rarity == 2:
		ability_damage *= rarity_rare_scaling
	if rarity == 3:
		ability_damage *= rarity_epic_scaling
	if rarity == 4:
		ability_damage *= rarity_legendary_scaling
