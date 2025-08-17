extends Node2D
class_name Platformer

const GRAVITY : float = 5000

@export var host : CharacterBody2D
@export var speed : int = 200
@export var acceleration : float = 0.2

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var accept_input : bool = true

func _physics_process(delta: float) -> void:
	speed = get_parent().speed
	host.velocity.y += get_gravity() * delta
	#if Input.is_action_just_pressed("Move_Up"):
		#jump()
	host.move_and_slide()

func jump():
	host.velocity.y = jump_velocity

func get_gravity():
	return jump_gravity if host.velocity.y < 0.0 else fall_gravity

func get_direction():
	var input : Vector2 = Vector2()
	if Input.is_action_pressed("Move_Left"):
		input.x -=1
	if Input.is_action_pressed("Move_Right"):
		input.x +=1
	return input

func move():
	var dir = get_direction()
	host.velocity = host.velocity.lerp(dir * speed, acceleration)
