extends Node2D

@export_group("Health Component Exports")
@export var parent : CharacterBody2D
@export var health : int = 10
@export var is_player : bool = false
@export var is_enemy : bool = false

@export_group("Hit Effect Component Exports")
@export var sprite : Sprite2D
@export var effects_active : bool = false

func _ready() -> void:
	base_vibration_offset = vibration_offset
	base_hit_flash_color = hit_flash_color
	base_hit_scale_stretch = hit_scale_stretch
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

#KEEP WORKING ON THIS
#Trying to make the sprite vibrate in place, flash a color, and stretch a bit when hit
func take_damage(damage):
	health -= damage
	if sprite and effects_active:
		$EffectPlayer.play("hit_flash")
		#WORK HERE
	if parent.has_method("flash"):
		parent.flash()
	if health <= 0:
		if parent.has_method("die"):
			parent.die()
