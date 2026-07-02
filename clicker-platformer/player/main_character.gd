extends CharacterBody2D
class_name Player

@onready var effect_player: AnimationPlayer = $EffectPlayer

const GRAVITY : float = 2000
const FALL_GRAVITY : float = 8000
const JUMP_POWER : float = 2000
const JUMP_ACCELERATION : float = 0.75

@export var host : CharacterBody2D
@export var speed : int = 200
@export var acceleration : float = 0.2

var accept_input : bool = true
var air_jump : bool = true
var is_alive : bool = true

@export var max_health : int = 10
var health : int = 1

func _ready() -> void:
	SignalBus.floor_ended.connect(save_info)
	SignalBus.register_player.emit(self)
	SignalBus.player_health_change.emit()
	SignalBus.health_pickup_get.connect(upgrade_health)
	health = InfoManager.player_health
	max_health = InfoManager.player_max_health
	$HealthComponent.health = health

func reset_health():
	health = InfoManager.player_health
	$HealthComponent.health = health

func flash():
	health = $HealthComponent.health
	SignalBus.player_health_change.emit()
	SignalBus.frame_freeze.emit(0.2, .1)
	effect_player.play("flash")

func die():
	is_alive = false
	visible = false
	SignalBus.player_die.emit()

func upgrade_health(num):
	if max_health == health:
		max_health += num
	health += num*2
	if health > max_health:
		health = max_health
	$HealthComponent.health = health
	SignalBus.player_health_change.emit()

func save_info():
	InfoManager.player_health = health
	InfoManager.player_max_health = max_health
