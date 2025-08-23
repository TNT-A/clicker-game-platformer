extends CharacterBody2D
class_name Projectile

@export var dir : Vector2 = Vector2(1,1)
@export var speed : int = 300
@export var damage : int = 3

@export var speed_slow : float = 1

@export var pierce : bool = false
@export var explosive : bool = false
@export var bouncy : bool = false
var can_bounce : bool = true

func _physics_process(delta: float) -> void:
	$Sprite2D.rotation = dir.angle()
	velocity = speed * dir
	speed *= speed_slow
	if speed <= 1:
		destroy()
	if (is_on_ceiling() or is_on_floor() or is_on_wall()) and explosive:
		destroy()
	if is_on_wall() and bouncy and can_bounce:
		dir.x *= -1
		can_bounce = false
		$BounceTimer.start()
	if (is_on_ceiling() or is_on_floor()) and bouncy and can_bounce:
		dir.y *= -1
		can_bounce = false
		$BounceTimer.start()
	if (is_on_ceiling() or is_on_floor() or is_on_wall()) and (!explosive or !bouncy):
		destroy()
	move_and_slide()

func _on_damage_zone_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player") and $DamageZone.hits_player:
		destroy()
	if body.is_in_group("enemy") and $DamageZone.hits_enemy:
		destroy()

func destroy():
	if explosive:
		spawn_bullets()
	queue_free()

func spawn_bullets():
	for i in range(randi_range(3,5)):
		var rand_x : int = randi_range(-1,1)
		var rand_y : int = randi_range(-1,1)
		if rand_y == 0 and rand_x == 0:
			var rand_num = randi_range(0,3)
			if rand_num == 0:
				rand_x = -1
			if rand_num == 1:
				rand_x = 1
			if rand_num == 2:
				rand_y = -1
			if rand_num == 3:
				rand_x = 1
		create_shot(Vector2(rand_x, rand_y), 200, 1, false)

var small_bullet : PackedScene = preload("res://player_bullet/small_bullet.tscn")
func create_shot(dir, speed, power, follow_player:bool):
	var new_projectile : Projectile = small_bullet.instantiate()
	new_projectile.dir = dir
	new_projectile.speed = 100
	new_projectile.damage = power
	new_projectile.speed_slow = .85
	get_parent().add_child(new_projectile)
	new_projectile.global_position = global_position
