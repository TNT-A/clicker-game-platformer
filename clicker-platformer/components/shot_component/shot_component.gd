extends Node2D
class_name ShotComponent

signal shot_finished

@export var is_player : bool = false

@export var shot_patterns : Array[ShotPatternResource] = []

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

func call_pattern(dir : Vector2, shot_pattern_num : int):
	var shot_pattern : ShotPatternResource
	if shot_pattern_num < shot_patterns.size():
		shot_pattern = shot_patterns[shot_pattern_num]
		var shot_list : Dictionary[ShotDataResource, float] = shot_pattern.shot_list
		for shot in shot_list.keys():
			var shot_cooldown : float = shot_list[shot]
			var cur_shot : ShotDataResource = shot
			shot_cooldown += cur_shot.shot_delay * cur_shot.shot_num
			call_shot(dir, shot)
			await get_tree().create_timer(shot_cooldown).timeout
	shot_finished.emit()

func call_shot(dir : Vector2, shot_data : ShotDataResource):
	var shot_callable = Callable(self,  shot_data.get_shot_type() + "_shot")
	var new_dir : Vector2 
	var og_rad : float = dir.angle()
	og_rad += deg_to_rad(shot_data.direction_offset)
	var offset_dir : Vector2 = Vector2(cos(og_rad), sin(og_rad)) 
	new_dir = dir + offset_dir
	shot_callable.call(new_dir, shot_data)

##Code for shooting straight forward once
func single_shot(dir : Vector2, shot_data : ShotDataResource):
	var projectile_resource : ProjectileResource = shot_data.projectile_type
	create_shot_from_resource(dir, projectile_resource)

##Code for shooting multiple bullets in a cone (bullet num and cone degrees taken in)
func spread_shot(dir : Vector2, shot_data : ShotDataResource):
	var projectile_resource : ProjectileResource = shot_data.projectile_type
	var shot_num : int = shot_data.shot_num
	var shot_cone : float = deg_to_rad(shot_data.cone_degree)
	if shot_num > 1:
		var dir_rad : float = dir.angle()
		var degree_step : float = shot_cone/(shot_num - 1)
		var start_degree = dir_rad - (shot_cone/2)
		var cur_degree = start_degree
		for num in shot_num:
			var new_dir : Vector2 = Vector2(cos(cur_degree), sin(cur_degree)) 
			create_shot_from_resource(new_dir, projectile_resource)
			cur_degree += degree_step
	else:
		single_shot(dir, shot_data)

##Code for shooting multiple bullets around the creator
func surround_shot(dir : Vector2, shot_data : ShotDataResource):
	var projectile_resource : ProjectileResource = shot_data.projectile_type
	var shot_num : int = shot_data.shot_num
	var shot_cone : float = deg_to_rad(360)
	if shot_num > 1:
		var dir_rad : float = dir.angle()
		var degree_step : float = shot_cone/(shot_num)
		var start_degree = dir_rad - (shot_cone/2)
		var cur_degree = start_degree
		for num in shot_num:
			var new_dir : Vector2 = Vector2(cos(cur_degree), sin(cur_degree)) 
			create_shot_from_resource(new_dir, projectile_resource)
			cur_degree += degree_step
	else:
		single_shot(dir, shot_data)

##Same as single, but multiple times with a given shot delay
func burst_single_shot(dir : Vector2, shot_data : ShotDataResource):
	var projectile_resource : ProjectileResource = shot_data.projectile_type
	var shot_num : int = shot_data.shot_num
	var shot_delay : float = shot_data.shot_delay
	for num in shot_num:
		create_shot_from_resource(dir, projectile_resource)
		await get_tree().create_timer(shot_delay).timeout

##Same as spread, but each shot fires individually with a given shot delay
func burst_spread_shot(dir : Vector2, shot_data : ShotDataResource):
	var projectile_resource : ProjectileResource = shot_data.projectile_type
	var shot_num : int = shot_data.shot_num
	var shot_cone : float = deg_to_rad(shot_data.cone_degree)
	var shot_delay : float = shot_data.shot_delay
	if shot_num > 1:
		var dir_rad : float = dir.angle()
		var degree_step : float = shot_cone/(shot_num - 1)
		var start_degree = dir_rad - (shot_cone/2)
		var cur_degree = start_degree
		for num in shot_num:
			print(dir_rad)
			var new_dir : Vector2 = Vector2(cos(cur_degree), sin(cur_degree)) 
			create_shot_from_resource(new_dir, projectile_resource)
			cur_degree += degree_step
			await get_tree().create_timer(shot_delay).timeout
	else:
		single_shot(dir, shot_data)

##Same as surround, but each shot fires individually with a given shot delay
func burst_surround_shot(dir : Vector2, shot_data : ShotDataResource):
	var projectile_resource : ProjectileResource = shot_data.projectile_type
	var shot_num : int = shot_data.shot_num
	var shot_cone : float = deg_to_rad(360)
	var shot_delay : float = shot_data.shot_delay
	if shot_num > 1:
		var dir_rad : float = dir.angle()
		var degree_step : float = shot_cone/(shot_num)
		var start_degree = dir_rad - (shot_cone/2)
		var cur_degree = start_degree
		for num in shot_num:
			print(dir_rad)
			var new_dir : Vector2 = Vector2(cos(cur_degree), sin(cur_degree)) 
			create_shot_from_resource(new_dir, projectile_resource)
			cur_degree += degree_step
			await get_tree().create_timer(shot_delay).timeout
	else:
		single_shot(dir, shot_data)
