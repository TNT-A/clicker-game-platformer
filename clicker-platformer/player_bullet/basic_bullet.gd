extends CharacterBody2D
class_name Projectile

@export var dir : Vector2 = Vector2(1,1)
@export var speed : int = 300
@export var damage : int = 3

@export var speed_slow : float = 1

@export var pierce : bool = false

func _physics_process(delta: float) -> void:
	$Sprite2D.rotation = dir.angle()
	velocity = speed * dir
	move_and_slide()
	speed *= speed_slow
	if speed <= 1:
		destroy()


func _on_damage_zone_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player") and $DamageZone.hits_player and !pierce:
		destroy()
	if body.is_in_group("enemy") and $DamageZone.hits_enemy and !pierce:
		destroy()

func destroy():
	queue_free()
