extends CharacterBody2D
class_name Player

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
	health = max_health
	SignalBus.register_player.emit(self)
	SignalBus.player_health_change.emit()

func flash():
	health = $HealthComponent.health
	SignalBus.player_health_change.emit()
	$HealthComponent/CollisionShape2D.disabled = true
	await get_tree().create_timer(1)
	$HealthComponent/CollisionShape2D.disabled = false

func die():
	is_alive = false
	visible = false
	SignalBus.player_die.emit()
