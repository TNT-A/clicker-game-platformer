extends Node2D

var ability_list : Array[String] = [
	"basic_shot",
	"basic_slash",
	"octo_shot",
	"wild_slash",
	"quick_shot",
	"snipe",
	"multi_slash",
	"target_slash",
	"bomb_shot",
	"bomb_barage",
	"cluster_blast",
	"bounce_shot",
	"bouncy_blast",
	"random_bullshit",
]

var projectile_list : Array[PackedScene] = [
	preload("res://player_bullet/basic_bullet.tscn"),
	preload("res://player_bullet/small_bullet.tscn"),
	preload("res://player_bullet/basic_slash.tscn"),
	preload("res://player_bullet/bomb_bullet.tscn"),
	preload("res://player_bullet/bouncy_bullet.tscn")
]

var player : Player

func _ready() -> void:
	SignalBus.ability_use.connect(use_ability)
	await get_parent().ready
	player = InfoManager.player

func use_ability(num, power):
	var ability_callable = Callable(self, ability_list[num])
	ability_callable.call(power)

func create_shot(shot_num:int, dir, speed, power, follow_player:bool):
	var new_projectile : Projectile = projectile_list[shot_num].instantiate()
	new_projectile.dir = dir
	new_projectile.speed = speed
	new_projectile.damage = power
	if !follow_player:
		get_parent().get_parent().add_child(new_projectile)
	else:
		add_child(new_projectile)
	new_projectile.global_position = player.global_position
#
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#random_bullshit(3)

func basic_shot(power):
	create_shot(0, (get_global_mouse_position() - player.global_position).normalized(), 120, power, false)

func basic_slash(power):
	create_shot(2, (get_global_mouse_position() - player.global_position).normalized(), 360, power, true)

func octo_shot(power):
	create_shot(1, Vector2(0,1), 100, power, false)
	create_shot(1, Vector2(1,1), 100, power, false)
	create_shot(1, Vector2(1,0), 100, power, false)
	create_shot(1, Vector2(0,-1), 100, power, false)
	create_shot(1, Vector2(-1,0), 100, power, false)
	create_shot(1, Vector2(-1,-1), 100, power, false)
	create_shot(1, Vector2(1,-1), 100, power, false)
	create_shot(1, Vector2(-1,1), 100, power, false)

func wild_slash(power):
	create_shot(2, Vector2(0,1), 200, power, true)
	await get_tree().create_timer(.1).timeout
	create_shot(2, Vector2(1,1), 200, power, true)
	await get_tree().create_timer(.1).timeout
	create_shot(2, Vector2(1,0), 200, power, true)
	await get_tree().create_timer(.1).timeout
	create_shot(2, Vector2(0,-1), 200, power, true)
	await get_tree().create_timer(.1).timeout
	create_shot(2, Vector2(-1,0), 200, power, true)
	await get_tree().create_timer(.1).timeout
	create_shot(2, Vector2(-1,-1), 200, power, true)
	await get_tree().create_timer(.1).timeout
	create_shot(2, Vector2(1,-1), 200, power, true)
	await get_tree().create_timer(.1).timeout
	create_shot(2, Vector2(-1,1), 200, power, true)

func quick_shot(power):
	for i in range(power):
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
		create_shot(1, Vector2(rand_x, rand_y), 100, 1, false)

func snipe(power):
	create_shot(1, (get_global_mouse_position() - player.global_position).normalized(), 500, power*2, false)

func multi_slash(power):
	for i in range(power):
		create_shot(2, (get_global_mouse_position() - player.global_position).normalized(), 300, 1, true)
		await get_tree().create_timer(.1).timeout

func target_slash(power):
	var new_projectile : Projectile = projectile_list[2].instantiate()
	new_projectile.dir = (get_global_mouse_position() - player.global_position).normalized()
	new_projectile.speed = 300
	new_projectile.damage = power
	get_parent().get_parent().add_child(new_projectile)
	new_projectile.global_position = get_global_mouse_position()

func bomb_shot(power):
	create_shot(3, (get_global_mouse_position() - player.global_position).normalized(), 300, power, false)

func bomb_barage(power):
	for i in range(power + 1):
		create_shot(3, (get_global_mouse_position() - player.global_position).normalized(), 200, 1, false)
		await get_tree().create_timer(.1).timeout

func cluster_blast(power):
	for i in range(power):
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
		create_shot(3, Vector2(rand_x, rand_y), 100, 0, false)

func bounce_shot(power):
	create_shot(4, (get_global_mouse_position() - player.global_position).normalized(), 300, power, false)

func bouncy_blast(power):
	for i in range(power):
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
		create_shot(4, Vector2(rand_x, rand_y), 300, 1, false)

func random_bullshit(power):
	for i in range(power + 1):
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
		create_shot(randi_range(0,4), Vector2(rand_x, rand_y), 300, 1, false)
