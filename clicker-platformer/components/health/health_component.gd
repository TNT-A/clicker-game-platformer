extends Node2D
class_name HealthComponent

signal damage_taken

@export_group("Health Component Exports")
@export var parent : CharacterBody2D
@export var health : int = 10
@export var is_player : bool = false
@export var is_enemy : bool = false

@export_group("Hit Effect Component Exports")
@export var sprite : Node
@export var effects_active : bool = false

@export_group("Stuff for animations!")
@export var animating : bool = false
@export var shake_intensity : float = 5.0
@export var flash_color : Color = Color.RED
@export var scale_max : Vector2 = Vector2(1.1, 1.1)
@export var cur_offset : Vector2 = Vector2(0, 0)
@export var cur_color_flash : Color = Color.RED
@export var cur_scale : Vector2 = Vector2(1.0, 1.0)

func _ready() -> void:
	setup_parent_health()

func setup_parent_health():
	if "health" in parent:
		health = parent.health
	if "max_health" in parent:
		health = parent.max_health

func _process(delta: float) -> void:
	if animating:
		animate_sprite()

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if is_enemy:
		if area.is_in_group("hurts_enemy"):
			take_damage(area.owner.damage)
	elif is_player:
		if area.is_in_group("hurts_player"):
			take_damage(1)

func take_damage(damage):
	health -= damage
	if sprite and effects_active:
		$EffectPlayer.play("hit_flash")
	set_parent_stats()
	if parent.has_method("flash"):
		parent.flash()
	if health <= 0:
		if parent.has_method("die"):
			parent.die()

func set_parent_stats():
	if "health" in parent:
		parent.health = health

func animate_sprite():
	sprite.offset = cur_offset
	sprite.modulate = cur_color_flash
	sprite.scale = cur_scale
