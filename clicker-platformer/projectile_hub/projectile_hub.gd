extends Node2D
class_name ProjectileHub

#!!!!!! ALL FUNCTIONS ARE UNTESTED !!!!!!!

@onready var player_projectiles: Node2D = $PlayerProjectiles
@onready var enemy_projectiles: Node2D = $EnemyProjectiles

##Returns a dictionary of every active projectile as well as if the projectile belongs to the player or an enemy
func get_projectiles() -> Dictionary[Projectile, String]:
	var projectile_list : Dictionary[Projectile, String]
	for child in player_projectiles.get_children():
		if is_instance_valid(child) and child is Projectile:
			var cur_child : Projectile = child
			projectile_list[cur_child] = "player"
	for child in enemy_projectiles.get_children():
		if is_instance_valid(child) and child is Projectile:
			var cur_child : Projectile = child
			projectile_list[cur_child] = "enemy"
	return projectile_list

#Queue every active projectile in the scene
func delete_all_projectiles():
	delete_player_projectiles()
	delete_enemy_projectiles()

#Trigger the destroy fuction of every projectile in the scene
func destroy_all_projectiles():
	destroy_player_projectiles()
	destroy_enemy_projectiles()

func delete_player_projectiles():
	var full_projectile_list : Dictionary[Projectile, String] = get_projectiles()
	for projectile in full_projectile_list.keys():
		if full_projectile_list[projectile] == "player":
			projectile.queue_free()

func destroy_player_projectiles():
	var full_projectile_list : Dictionary[Projectile, String] = get_projectiles()
	for projectile in full_projectile_list.keys():
		if full_projectile_list[projectile] == "player":
			projectile.destroy()

func delete_enemy_projectiles():
	var full_projectile_list : Dictionary[Projectile, String] = get_projectiles()
	for projectile in full_projectile_list.keys():
		if full_projectile_list[projectile] == "enemy":
			projectile.queue_free()

func destroy_enemy_projectiles():
	var full_projectile_list : Dictionary[Projectile, String] = get_projectiles()
	for projectile in full_projectile_list.keys():
		if full_projectile_list[projectile] == "enemy":
			projectile.destroy()
