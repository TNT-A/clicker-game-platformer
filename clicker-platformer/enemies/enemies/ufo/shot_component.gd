extends Node2D

var enemy_shot : PackedScene = preload("res://player_bullet/enemy_bullet.tscn")

func create_shot(dir, speed, power):
	var new_projectile : Projectile = enemy_shot.instantiate()
	new_projectile.dir = dir
	new_projectile.speed = speed
	new_projectile.damage = power
	get_parent().get_parent().add_child(new_projectile)
	new_projectile.global_position = get_parent().global_position
	
