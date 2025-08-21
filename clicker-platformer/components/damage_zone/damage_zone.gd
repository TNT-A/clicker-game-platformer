extends Area2D
class_name DamageZone

@export var hits_enemy : bool = false
@export var hits_player : bool = false

var parent : CharacterBody2D
var damage : int = 1

func _ready() -> void:
	if !is_instance_valid(parent):
		parent = get_parent()
	damage = parent.damage
	if hits_enemy:
		add_to_group("hurts_enemy")
	if hits_player:
		add_to_group("hurts_player")
