extends Node2D

@export var parent : CharacterBody2D
@export var health : int = 10

@export var is_player : bool = false
@export var is_enemy : bool = false

func _ready() -> void:
	if parent:
		health = parent.health
	if parent is Player:
		health = parent.max_health

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if is_enemy:
		if area.is_in_group("hurts_enemy"):
			take_damage(area.owner.damage)
	elif is_player:
		if area.is_in_group("hurts_player"):
			take_damage(1)

func take_damage(damage):
	health -= damage
	if parent.has_method("flash"):
		parent.flash()
	if health <= 0:
		if parent.has_method("die"):
			parent.die()
