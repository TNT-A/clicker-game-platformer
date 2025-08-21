extends Node2D

var ability_list : Array[String] = [
	"basic_shot",
	"basic_slash",
	"basic_shield"
]

var projectile_list : Array[PackedScene] = [
	preload("res://player_bullet/basic_bullet.tscn"),
	preload("res://player_bullet/small_bullet.tscn"),
	preload("res://player_bullet/basic_slash.tscn"),
	
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

func basic_shot(power):
	create_shot(0, (get_global_mouse_position() - player.global_position).normalized(), 120, power, false)

func basic_slash(power):
	create_shot(2, (get_global_mouse_position() - player.global_position).normalized(), 360, power, true)

func basic_shield(power):
	print("*Protects You* ", power)
