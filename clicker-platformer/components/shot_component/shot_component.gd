extends Node2D
class_name ShotComponent

@export var is_player : bool = false

#var base_enemy_shot : PackedScene = preload("res://player_bullet/enemy_bullet.tscn")
var projectile_hub : ProjectileHub 

func _ready() -> void:
	SignalBus.register_manager.connect(manager_set)
	if is_instance_valid(InfoManager.game_manager) and is_instance_valid(InfoManager.game_manager.projectile_hub):
		projectile_hub = InfoManager.game_manager.projectile_hub

func manager_set():
	if is_instance_valid(InfoManager.game_manager) and is_instance_valid(InfoManager.game_manager.projectile_hub):
		projectile_hub = InfoManager.game_manager.projectile_hub

func create_shot(dir : Vector2, speed : float, damage : float, projectile_scene : PackedScene):
	var new_projectile : Projectile = projectile_scene.instantiate()
	new_projectile.dir = dir
	new_projectile.speed = speed
	new_projectile.damage = damage
	if projectile_hub:
		if is_player:
			projectile_hub.player_projectiles.add_child(new_projectile)
		else:
			projectile_hub.enemy_projectiles.add_child(new_projectile)
	else:
		if is_instance_valid(InfoManager.game_manager) and is_instance_valid(InfoManager.game_manager.projectile_hub):
			projectile_hub = InfoManager.game_manager.projectile_hub
			if is_player:
				projectile_hub.player_projectiles.add_child(new_projectile)
			else:
				projectile_hub.enemy_projectiles.add_child(new_projectile)
		else:
			get_parent().get_parent().add_child(new_projectile)
	new_projectile.global_position = get_parent().global_position

func create_shot_from_resource(dir : Vector2, projectile_resource : ProjectileResource):
	var new_projectile : Projectile = projectile_resource.projectile_scene.instantiate()
	new_projectile.dir = dir
	new_projectile.speed = projectile_resource.projectile_speed
	new_projectile.damage = projectile_resource.projectile_damage
	if projectile_hub:
		if is_player:
			projectile_hub.player_projectiles.add_child(new_projectile)
		else:
			projectile_hub.enemy_projectiles.add_child(new_projectile)
	else:
		get_parent().get_parent().add_child(new_projectile)
	new_projectile.global_position = get_parent().global_position
