extends CharacterBody2D

const GRAVITY : float = 2000
const FALL_GRAVITY : float = 8000
const JUMP_POWER : float = 2000
const JUMP_ACCELERATION : float = 0.75

@export var host : CharacterBody2D
@export var speed : int = 200
@export var acceleration : float = 0.2

var accept_input : bool = true
var air_jump : bool = true

func _ready() -> void:
	SignalBus.register_player.emit(self)
