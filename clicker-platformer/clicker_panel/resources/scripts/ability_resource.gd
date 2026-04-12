#Has all the info needed for the ability panel & clicker to set abilities

extends Resource
class_name AbilityResource

#For ability setting
@export var ability_name : String = "Basic Shot"
@export var ability_num : int = 0
@export var ability_max : float = 5
@export var ability_damage : float = 3

@export var rarity : int = 0

#For pickups
@export var damage_level : int = 0
@export var power_level : int = 0
@export var clicker_level : int = 0
@export var length_level : int = 0
